extends Node2D


func _physics_process(delta: float) -> void:
	visible = false
	for node in get_tree().get_nodes_in_group("discs"):
		if node.hovered and not node.bought:
			visible = true
