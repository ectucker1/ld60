extends Label


func _process(_delta: float) -> void:
	visible = ScoreManager.competitor_score > 0
	text = "$NFLX: %s" % StringUtil.thousands_sep(ScoreManager.competitor_score)
