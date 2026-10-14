extends Node2D

@onready
var next_button: Button = $UI/NextButton

func _ready() -> void:
	PixelPerfect.enabled = true
	next_button.pressed.connect(func(): TransitionLayer.transition_to("res://test/pixel_perfect/scene2.tscn"))


func _process(_delta: float) -> void:
	DebugOverlay.draw_vector_from(Vector2.ZERO, Vector2.ONE * 64, Color.RED)
	DebugOverlay.draw_point(InputUtil.get_global_mouse_position(self), Color.BLUE)
