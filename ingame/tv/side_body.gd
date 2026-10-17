class_name SideBody
extends StaticBody2D

var _bumper_tween: Tween

func hit(collision: KinematicCollision2D) -> void:
	if _bumper_tween != null:
		_bumper_tween.stop()
	_bumper_tween = get_tree().create_tween()
	_bumper_tween.tween_property($Bumper, "position", collision.get_normal() * 2, 0.1)
	_bumper_tween.tween_callback(func(): $Bumper.position = Vector2(0, 0)).set_delay(0.15)
