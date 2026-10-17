@tool
extends Sprite2D


func _ready() -> void:
	texture = get_parent().get_node("SubViewport").get_texture()
	material = material.duplicate()
	material.set("shader_parameter/resolution", texture.get_size())
