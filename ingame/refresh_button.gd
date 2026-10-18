class_name RefreshButton
extends Button


@export
var shop: Node

var message := ""


func _ready() -> void:
	mouse_entered.connect(func(): TooltipManager.try_show(get_parent()))
	mouse_exited.connect(func(): TooltipManager.try_remove(get_parent()))

func _process(delta: float) -> void:
	disabled = !shop.can_refresh()
	if disabled:
		message = "Buy at least two DvDs before refreshing."
	else:
		message = "Refresh the shop!"

func _pressed() -> void:
	GlobalSounds.play("RefreshShop")
	shop.refresh()
