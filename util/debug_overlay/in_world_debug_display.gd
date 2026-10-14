extends Node


var drawables := []


func transform_to_screen(global_pos: Vector2) -> Vector2:
	if PixelPerfect.enabled:
		# World position to pixel position within the pixel viewport
		var viewport_pos = PixelPerfect.viewport.canvas_transform * global_pos
		viewport_pos += PixelPerfect.viewport_offset
		# Pixel position within the viewport texture to the display sprite's local space
		var sprite = PixelPerfect.display_sprite
		var sprite_local_pos = viewport_pos + sprite.get_rect().position
		# Display sprite's local space to the root viewport
		return sprite.get_global_transform_with_canvas() * sprite_local_pos
	else:
		return get_viewport().canvas_transform * global_pos


class DebugVector:
	var from: Vector2
	var vector: Vector2
	var color: Color

	func _init(p_from: Vector2, p_vector: Vector2, p_color: Color) -> void:
		self.from = p_from
		self.vector = p_vector
		self.color = p_color
	
	func draw(canvas: CanvasItem, to_screen: Callable) -> void:
		canvas.draw_line(to_screen.call(from), to_screen.call(from + vector), color, 5)


class DebugPoint:
	var point: Vector2
	var color: Color
	
	func _init(p_point: Vector2, p_color: Color) -> void:
		self.point = p_point
		self.color = p_color
	
	func draw(canvas: CanvasItem, to_screen: Callable) -> void:
		canvas.draw_circle(to_screen.call(point), 8, color)


func draw_vector_from(from: Vector2, vector: Vector2, color: Color) -> void:
	drawables.push_back(DebugVector.new(from, vector, color))
	canvas.queue_redraw()


func draw_line_between(from: Vector2, to: Vector2, color: Color) -> void:
	drawables.push_back(DebugVector.new(from, to - from, color))
	canvas.queue_redraw()


func draw_point(point: Vector2, color: Color) -> void:
	drawables.push_back(DebugPoint.new(point, color))
	canvas.queue_redraw()


@onready
var canvas: Node2D = $Canvas

func draw_canvas() -> void:
	var to_screen = func(global_pos): return transform_to_screen(global_pos)
	for drawable in drawables:
		drawable.draw(canvas, to_screen)
	drawables.clear()


func _process(_delta: float) -> void:
	canvas.visible = DebugOverlayDisplay.visible
