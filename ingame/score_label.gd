extends Label


func _process(_delta: float) -> void:
	text = "$BBI: %s" % StringUtil.thousands_sep(ScoreManager.score)
