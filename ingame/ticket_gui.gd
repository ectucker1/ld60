class_name TicketGUI
extends Area2D


func _mouse_enter() -> void:
	TooltipManager.try_show(self)

func _mouse_exit() -> void:
	TooltipManager.try_remove(self)
