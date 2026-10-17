@tool
extends Node2D


@export
var world_size: Vector2i

func _ready() -> void:
	$Left.global_position = Vector2i(-10, 0)
	$Right.global_position = Vector2i(world_size.x + 10, 0)
	$Top.global_position = Vector2i(0, -10)
	$Bottom.global_position = Vector2i(0, world_size.y + 10)
	$Logo.global_position = Vector2(float(world_size.x) / 2, float(world_size.y) / 2)
