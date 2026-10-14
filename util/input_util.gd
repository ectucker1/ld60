class_name InputUtil
extends Node


## Gets the mouse position in global coordinates.
static func get_global_mouse_position(node: Node) -> Vector2:
	var viewport = node.get_viewport()
	if PixelPerfect.enabled and viewport == PixelPerfect.viewport:
		return _get_pixel_perfect_mouse_position()
	var viewportPos = viewport.get_mouse_position()
	return viewport.canvas_transform.affine_inverse() * viewportPos


## Gets the mouse position in global coordinates of the pixel perfect viewport.
static func _get_pixel_perfect_mouse_position() -> Vector2:
	var display = PixelPerfect.display_sprite
	var root_pos = display.get_viewport().get_mouse_position()
	# Root viewport to the display sprite's local space
	var sprite_local_pos = display.get_global_transform_with_canvas().affine_inverse() * root_pos
	# Display sprite's local space to pixel position within the viewport texture
	var viewport_pos = sprite_local_pos - display.get_rect().position
	# Remove subpixel offset
	viewport_pos -= PixelPerfect.viewport_offset
	return PixelPerfect.viewport.canvas_transform.affine_inverse() * viewport_pos
