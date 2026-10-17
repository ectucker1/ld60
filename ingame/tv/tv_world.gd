@tool
extends Node2D


@export
var world_size: Vector2i

func _ready() -> void:
	$Left.global_position = Vector2i(-10, 0)
	$Right.global_position = Vector2i(world_size.x + 10, 0)
	$Top.global_position = Vector2i(0, -10)
	$Bottom.global_position = Vector2i(0, world_size.y + 10)
	
	$TLCorner.global_position = Vector2(0, 0)
	$TRCorner.global_position = Vector2(world_size.x, 0)
	$BLCorner.global_position = Vector2(0, world_size.y)
	$BRCorner.global_position = Vector2(world_size.x, world_size.y)
	
	$Logo.global_position = Vector2(float(world_size.x) / 2, float(world_size.y) / 2)
