extends Label


func _process(_delta: float) -> void:
	text = "$BBI: %s" % StringUtil.thousands_sep(ScoreManager.score - ScoreManager.competitor_score)
	if ScoreManager.competitor_score > 0 and (ScoreManager.score - ScoreManager.competitor_score) < 500:
		AnimPlayerUtil.play_if_not($AnimationPlayer, "OhNo")
