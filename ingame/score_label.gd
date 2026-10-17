extends Label


func _process(_delta: float) -> void:
	text = "Earnings: %s$" % StringUtil.thousands_sep(ScoreManager.score)
