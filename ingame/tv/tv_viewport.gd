@tool
extends SubViewport


@export
var world_size: Vector2i = Vector2i(16, 9):
	set(value):
		world_size = value
		size = world_size
		if is_node_ready():
			$InsideTVWorld.world_size = world_size
		notify_property_list_changed()

func _ready() -> void:
	$InsideTVWorld.world_size = world_size
