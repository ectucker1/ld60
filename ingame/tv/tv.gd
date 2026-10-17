class_name  TV
extends Node2D


var slots: Array[DiscSlot] = []

func _ready() -> void:
	for node in $Slots.get_children():
		if node is DiscSlot:
			slots.push_back(node)

func get_discs() -> Array[Disc]:
	var result: Array[Disc] = []
	for slot in slots:
		if slot.inserted_disc != null and slot.inserted_disc.disc != null:
			result.push_back(slot.inserted_disc.disc)
	return result

func get_speed_mult() -> float:
	var mult = 1.0
	for disc in get_discs():
		mult += disc.speed_mult
	return mult

func _physics_process(delta: float) -> void:
	DebugOverlay.add_message(self, "%s Speed" % name, "%f" % get_speed_mult())
