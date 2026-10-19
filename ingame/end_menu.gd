extends MarginContainer


func update_menu():
	if ReplayManager.is_fast_mode:
		$VBoxContainer/ScoreLabel.text = "Total $BBI: %s (x2 Mode)" % StringUtil.thousands_sep(ScoreManager.total_earnings_highscore)
	else:
		$VBoxContainer/ScoreLabel.text = "Total $BBI: %s" % StringUtil.thousands_sep(ScoreManager.total_earnings_highscore)
