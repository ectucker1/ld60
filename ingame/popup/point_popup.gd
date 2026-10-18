extends Node2D


func set_score(score: int) -> void:
	$CenterContainer/Label.text = StringUtil.thousands_sep(score)
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2.UP * (5 + 0.5 * score), 0.2 + 0.01 * score)
	tween.tween_callback(self.queue_free).set_delay(0.4 + 0.01 * score)
