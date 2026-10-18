class_name ExtraDiscDisc
extends Disc


var logo_scene = preload("res://ingame/logo/logo.tscn")
var spawned_logo: Logo

func move_node_to_tv_world(node: Node2D, tv: TV):
	if node.get_parent() != tv.get_inside_world():
		if node.get_parent() != null:
			node.get_parent().remove_child(node)
		tv.get_inside_world().add_child(node)
		node.tv = tv
		node.global_position = tv.get_global_center()

func on_physics_process(this: TVContext, _delta: float) -> void:
	if spawned_logo == null and this.tv.started:
		spawned_logo = logo_scene.instantiate()
		move_node_to_tv_world(spawned_logo, this.tv)
	elif spawned_logo != null:
		if this.tv.started:
			move_node_to_tv_world(spawned_logo, this.tv)

func reset() -> void:
	if spawned_logo != null and spawned_logo.get_parent() != null:
		spawned_logo.get_parent().remove_child(spawned_logo)
