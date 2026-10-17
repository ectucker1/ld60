extends Node2D


var previous_current: Node2D


func _process(delta: float) -> void:
	visible = TooltipManager.current != null
	if TooltipManager.current != null:
		global_position = TooltipManager.current.global_position + Vector2(8, 8)
		if previous_current != TooltipManager.current:
			update_text(TooltipManager.current)
			previous_current = TooltipManager.current

func update_text(source: Node2D) -> void:
	for child in get_children():
		child.visible = false
	
	if source is DiscDisplay:
		$DiscTooltip.visible = true
		$DiscTooltip/PanelContainer/VBoxContainer/DiscName.text = source.disc.name
		$DiscTooltip/PanelContainer/VBoxContainer/DiscDesc.text = source.disc.desc
