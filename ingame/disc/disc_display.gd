class_name DiscDisplay
extends Area2D


@export
var disc: Disc


var hovered := false
var last_hovered := INF


var previous_slot: DiscSlot
var target_slots: Array
var can_renter := false


var bought := false

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)
	if not Engine.is_editor_hint():
		make_disc_unique()
	add_to_group("discs")

func make_disc_unique() -> void:
	disc.set_meta("original_path", disc.resource_path)
	disc = disc.duplicate()

func _mouse_enter() -> void:
	last_hovered = 0.0
	hovered = true
	if DragManager.dragged_object == null:
		TooltipManager.try_show(self)
	for other_disc in get_tree().get_nodes_in_group("discs"):
		if other_disc.disc.get_meta("original_path") == self.disc.get_meta("original_path"):
			other_disc.get_node("Highlight").visible = true

func _mouse_exit() -> void:
	hovered = false
	TooltipManager.try_remove(self)
	for other_disc in get_tree().get_nodes_in_group("discs"):
		other_disc.get_node("Highlight").visible = false

func _area_entered(area: Area2D) -> void:
	if area is DiscSlot:
		target_slots.push_back(area)

func _area_exited(area: Area2D) -> void:
	if target_slots.count(area) > 0:
		target_slots.erase(area)
	if previous_slot == area:
		can_renter = true


func start_dragging() -> void:
	if DragManager.dragged_object == null:
		DragManager.dragged_object = self
		TooltipManager.try_remove(self)
		GlobalSounds.play("CDPickup")

		if previous_slot != null:
			previous_slot.remove(self)

func drop() -> void:
	if target_slots.size() == 1 and (target_slots.front() != previous_slot or can_renter):
		DragManager.dragged_object = null
		
		# Swap with previous disc
		if target_slots.front().inserted_disc != null:
			var swap_disc = target_slots.front().inserted_disc
			if swap_disc.disc.get_meta("original_path") == disc.get_meta("original_path") and disc.combine_to != null:
				# Combine discs!
				disc = disc.combine_to
				make_disc_unique()
				swap_disc.start_dragging()
				swap_disc.queue_free()
			else:
				swap_disc.start_dragging()
				swap_disc.can_renter = false
		# Insert into slot
		previous_slot = target_slots.front()
		target_slots.front().insert(self)
		
		can_renter = true
	elif previous_slot != null and previous_slot.inserted_disc == null:
		DragManager.dragged_object = null
		previous_slot.insert(self)
		can_renter = true

func _physics_process(delta: float) -> void:
	if not hovered:
		last_hovered += delta
	
	if last_hovered < 0.4 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if DragManager.dragged_object == null and (bought or ScoreManager.tickets > 0):
			if not bought:
				ScoreManager.tickets -= 1
				bought = true
			start_dragging()
	elif DragManager.dragged_object == self and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		drop()

	if DragManager.dragged_object == self:
		global_position = InputUtil.get_global_mouse_position(self)
	
	# Show the right disc texture
	match disc.tier:
		1:
			$Sprite2D.texture = preload("res://ingame/disc/disc_common.png")
		2:
			$Sprite2D.texture = preload("res://ingame/disc/disc_uncommon.png")
		3:
			$Sprite2D.texture = preload("res://ingame/disc/disc_rare.png")
		4:
			$Sprite2D.texture = preload("res://ingame/disc/disc_unique.png")
