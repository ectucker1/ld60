extends Button

func _pressed() -> void:
	ScoreManager.score = 0
	GlobalMenu.menu_zone.hide_menus()
