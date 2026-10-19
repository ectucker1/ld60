extends Label


@onready
var anim_player = $AnimationPlayer

func _process(_delta: float) -> void:
	text = "$BBI: %s" % StringUtil.thousands_sep(ScoreManager.score - ScoreManager.competitor_score)
	if ScoreManager.competitor_score > 0 and (ScoreManager.score - ScoreManager.competitor_score) < 5000:
		AnimPlayerUtil.play_if_not(anim_player, "OhNo")
	else:
		anim_player.stop()
