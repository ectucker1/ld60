class_name MenuZone
extends Sprite2D


func _ready() -> void:
	visible = true
	GlobalMenu.menu_zone = self
	for menu in $Control.get_children():
		menu.visible = menu.name == "MainMenu"

func hide_menus():
	$AnimationPlayer.play("HideMenus")
	for menu in $Control.get_children():
		menu.visible = false

func show_menu(menu_name: String):
	$AnimationPlayer.play("ShowMenus")
	for menu in $Control.get_children():
		menu.visible = menu.name == menu_name
