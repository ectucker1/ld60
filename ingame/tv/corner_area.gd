class_name CornerArea
extends Area2D

var _bumper_tween: Tween

func _ready() -> void:
	body_entered.connect(_body_entered)
	$Bumper.scale = Vector2(0, 0)

func _body_entered(body: PhysicsBody2D) -> void:
	if body is Logo:
		body.hit_corner()
		if _bumper_tween != null:
			_bumper_tween.stop()
		_bumper_tween = get_tree().create_tween()
		_bumper_tween.tween_property($Bumper, "scale", Vector2(1, 1), 0.2)
		_bumper_tween.tween_callback(func(): $Bumper.scale = Vector2(0, 0)).set_delay(0.25)
	
