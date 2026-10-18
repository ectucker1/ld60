extends Node2D


var previous_current: Node2D


func _process(delta: float) -> void:
	visible = TooltipManager.current != null
	if TooltipManager.current != null:
		if previous_current != TooltipManager.current:
			update_text(TooltipManager.current)
			previous_current = TooltipManager.current
		
		var target := TooltipManager.current.global_position + Vector2(8, 8)
		var overflow := target.x + get_tooltip_width() - PixelPerfect.viewport_base_size.x / 2
		if overflow > 0:
			target.x -= overflow
		
		global_position = target
	else:
		previous_current = null

func get_tooltip_width() -> float:
	for child in get_children():
		if child.visible and child is Control:
			child.update_minimum_size()
			var value = child.size.x
			return value
	return 0.0

func owns_duplicate_disc(display: DiscDisplay):
	for disc_display in get_tree().get_nodes_in_group("discs"):
		if disc_display == display:
			continue
		if disc_display.bought and disc_display.disc.get_meta("original_path") == display.disc.get_meta("original_path"):
			return true
	return false

func update_text(source: Node2D) -> void:
	for child in get_children():
		child.visible = false
	
	if source is DiscDisplay:
		$DiscTooltip.visible = true
		$DiscTooltip/Panel/Layout/DiscName.text = source.disc.name
		$DiscTooltip/Panel/Layout/DiscDesc.text = source.disc.desc
		$DiscTooltip/Panel/Layout/DiscCombineReminder.visible = owns_duplicate_disc(source)
		var name_label = $DiscTooltip/Panel/Layout/DiscName
		var tier_label = $DiscTooltip/Panel/Layout/DiscRarity
		match source.disc.tier:
			1:
				name_label.modulate = Color("ffffff")
				tier_label.text = "Tier 1"
			2:
				name_label.modulate = Color("8cd480")
				tier_label.text = "Tier 2"
			3:
				name_label.modulate = Color("60bcdb")
				tier_label.text = "Tier 3"
			4:
				name_label.modulate = Color("e29e28")
				tier_label.text = "Unique"
	elif source.get_child_count() > 0 and source.get_child(0) is RefreshButton:
		$MessageTooltip.visible = true
		$MessageTooltip/PanelContainer/Message.text = source.get_child(0).message
	elif source is TicketGUI:
		$TicketTooltip.visible = true
		if ScoreManager.tickets == 0:
			$TicketTooltip/PanelContainer/VBoxContainer/DiscName.text = "No Tickets"
			$TicketTooltip/PanelContainer/VBoxContainer/DiscDesc.text = "Next ticket at $%s earnings..." % StringUtil.thousands_sep(ScoreManager.next_ticket)
		elif ScoreManager.tickets == 1:
			$TicketTooltip/PanelContainer/VBoxContainer/DiscName.text = "1 Ticket"
			$TicketTooltip/PanelContainer/VBoxContainer/DiscDesc.text = "Spend tickets on DvDs!"
		else:
			$TicketTooltip/PanelContainer/VBoxContainer/DiscName.text = "%d Tickets" % ScoreManager.tickets
			$TicketTooltip/PanelContainer/VBoxContainer/DiscDesc.text = "Spend tickets on DvDs!"
	elif source is TV:
		$MessageTooltip.visible = true
		$MessageTooltip/PanelContainer/Message.text = "Unlock at $%s earnings." % StringUtil.thousands_sep(source.unlock_at)
