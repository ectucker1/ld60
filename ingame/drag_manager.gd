extends Node


var dragged_object: Node

func _process(_delta: float) -> void:
	if not is_instance_valid(dragged_object) or not dragged_object.is_inside_tree():
		dragged_object = null
