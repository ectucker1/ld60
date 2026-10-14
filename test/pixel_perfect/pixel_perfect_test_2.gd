extends Node2D

@onready
var back_button: Button = $UI/BackButton

func _ready() -> void:
	back_button.pressed.connect(func(): TransitionLayer.transition_to("res://test/pixel_perfect/pixel_perfect_test.tscn"))
