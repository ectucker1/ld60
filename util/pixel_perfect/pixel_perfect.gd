extends Node


## Whether or not we're rendering in the pixel-perfect viewport.
## You probably want to check this from the editor instead of using it at runtime.
@export
var enabled: bool:
	set(value):
		enabled = value
		if display_layer != null:
			display_layer.visible = value
		if value and is_node_ready():
			# Deferred since this may be set from the scene's _ready, while the root is busy adding it
			move_scene_to_viewport.call_deferred()

## Possible ways to handle scaling up the pixel viewport.
enum ScaleMode
{
	## Make sure at least the full height of the base resolution fits.
	KEEP_HEIGHT,
	## Make sure at least the full width of the base resolution fits.
	KEEP_WIDTH
}

## Determines how to handle scaling up the pixel viewport.
@export
var scale_mode := ScaleMode.KEEP_HEIGHT


## The scene currently shown in the pixel viewport.
## Use this instead of get_tree().current_scene, which is null once the scene is moved out of the root.
var current_scene: Node

## The initial size of the pixel viewport. This defines our "base" resolution.
var viewport_base_size: Vector2i
## Integer scaling factor from our base resolution to the high-res viewport.
var viewport_scale: int
## Subpixel offset
var viewport_offset: Vector2


## The low-res viewport.
@onready
var viewport = $PixelViewport

## Canvas layer in the high-res viewport.
@onready
var display_layer = $PixelLayer

## The sprite which actually displays our scene in the high-res viewport.
@onready
var display_sprite = $PixelLayer/Sprite2D


func _ready() -> void:
	# Process after the scene (e.g. cameras updating the canvas transform) so the display uses this frame's offset
	process_priority = 100
	viewport_base_size = viewport.size
	# Assigned here rather than as a ViewportTexture in the scene;
	# the autoload list in project settings throws an error otherwise.
	display_sprite.texture = viewport.get_texture()
	display_layer.visible = enabled
	
	# The initial scene doesn't emit scene_changed, so move it in manually
	if enabled:
		move_scene_to_viewport.call_deferred()
	get_tree().scene_changed.connect(_on_scene_changed)

	get_tree().root.size_changed.connect(_screen_size_changed)
	_screen_size_changed()


func _screen_size_changed() -> void:
	var screen_size = get_tree().root.size
	# Determine scaling factory
	match scale_mode:
		ScaleMode.KEEP_HEIGHT:
			viewport_scale = clamp(screen_size.y / viewport_base_size.y, 1, 100)
		ScaleMode.KEEP_WIDTH:
			viewport_scale = clamp(screen_size.x / viewport_base_size.x, 1, 100)
	# Expand viewport to cover the whole screen.
	var min_x = ceili(float(screen_size.x) / float(viewport_scale)) + 2
	var min_y = ceili(float(screen_size.y) / float(viewport_scale)) + 2 
	var viewport_size = Vector2i(min_x, min_y)
	viewport.size = viewport_size


func _process(_delta: float) -> void:
	_update_viewport_offset()
	_update_display_sprite()


# Finds the subpixel offset for the pixel-viewport camera.
func _update_viewport_offset() -> void:
	var origin = viewport.canvas_transform.origin
	# Match how the renderer snaps the canvas transform (see _canvas_get_transform in renderer_viewport.cpp).
	var size = viewport.size
	var snap_offset = Vector2(
		0.0 if size.x % 2 else -0.5,
		0.0 if size.y % 2 else -0.5
	)
	var snapped_origin = (origin + snap_offset).ceil()
	viewport_offset = snapped_origin - origin


# Positions the sprite showing the viewport in the center of the screen,
# shifted by the camera's subpixel offset
func _update_display_sprite() -> void:
	var display_scale = get_display_scale()
	display_sprite.scale = Vector2(display_scale, display_scale)
	var screen_size = display_sprite.get_viewport_rect().size
	# Center of the drawn texture in local space
	var local_center = display_sprite.get_rect().get_center()
	# Transform that center by scale to get its offset from the sprite's position
	display_sprite.position = Vector2(screen_size) / 2 - display_sprite.transform.basis_xform(local_center)
	display_sprite.position -= viewport_offset * display_scale


# Scale to draw the viewport at, in high-res units,
# so it ends up exactly viewport_scale window pixels per viewport pixel
# after the root window's stretch (e.g. canvas_items) is applied.
func get_display_scale() -> float:
	var stretch_scale = get_tree().root.get_stretch_transform().get_scale().x
	return viewport_scale / stretch_scale


# The pixel viewport doesn't receive input on its own.
# Forward events from the root viewport the same way SubViewportContainer does:
# non-positional events go before the root GUI unless a root control has focus,
# and positional events go only if the root GUI didn't consume them.
var _forwarded_event: InputEvent

func _input(event: InputEvent) -> void:
	if not _is_positional(event) and get_viewport().gui_get_focus_owner() == null:
		_forward_input(event)


func _unhandled_input(event: InputEvent) -> void:
	if event != _forwarded_event:
		_forward_input(event)


func _forward_input(event: InputEvent) -> void:
	_forwarded_event = event
	if not enabled or not viewport.can_process():
		return
	viewport.push_input(event.xformed_by(_get_root_to_viewport_transform()))


func _is_positional(event: InputEvent) -> bool:
	return event is InputEventMouse or event is InputEventScreenDrag \
		or event is InputEventScreenTouch or event is InputEventGesture


# Maps the root viewport's coordinates to the pixel viewport
func _get_root_to_viewport_transform() -> Transform2D:
	# Root viewport to the display sprite's local space
	var root_to_sprite = display_sprite.get_global_transform_with_canvas().affine_inverse()
	# Display sprite's local space to pixel position within the viewport texture.
	# Also remove the subpixel offset so positions line up with the unrounded canvas_transform,
	# matching InputUtil.get_global_mouse_position.
	var sprite_to_viewport = Transform2D(0.0, -display_sprite.get_rect().position - viewport_offset)
	return sprite_to_viewport * root_to_sprite


# Emitted right after the new scene is added to the root, before it's rendered.
func _on_scene_changed() -> void:
	if enabled:
		move_scene_to_viewport()


## Moves the tree's current scene into the pixel viewport, freeing the previous scene.
## Called automatically on scene changes, so this is only needed if the scene is changed some other way.
func move_scene_to_viewport() -> void:
	var scene = get_tree().current_scene
	# Scene has already been moved
	if scene == null:
		return

	# Free the previous scene
	if is_instance_valid(current_scene):
		if current_scene.get_parent() != null:
			current_scene.get_parent().remove_child(current_scene)
		current_scene.queue_free()

	get_tree().root.remove_child(scene)
	viewport.add_child(scene)
	current_scene = scene


## Reloads the scene in the pixel viewport.
## get_tree().reload_current_scene() would fail while the scene is in the viewport, so use this instead.
func reload_current_scene() -> Error:
	if not enabled:
		return get_tree().reload_current_scene()
	if not is_instance_valid(current_scene):
		return ERR_UNCONFIGURED
	return get_tree().change_scene_to_file(current_scene.scene_file_path)
