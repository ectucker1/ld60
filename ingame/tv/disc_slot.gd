class_name DiscSlot
extends Area2D


var inserted_disc: DiscDisplay

var _insert_tween: Tween

func _ready() -> void:
	add_to_group("disc_targets")

func remove(disc: DiscDisplay) -> bool:
	if inserted_disc == disc:
		if _insert_tween != null:
			_insert_tween.stop()
		inserted_disc = null
		return true
	return false

func insert(disc: DiscDisplay) -> bool:
	if inserted_disc != null:
		return false
	
	if _insert_tween != null:
		_insert_tween.stop()
	
	inserted_disc = disc
	disc.global_position = $HeldDiscAnimStart.global_position
	_insert_tween = get_tree().create_tween()
	_insert_tween.tween_property(disc, "global_position", $HeldDiscLoc.global_position, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	return true
