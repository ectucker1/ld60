@tool
extends Sprite2D


func _ready() -> void:
	if not Engine.is_editor_hint():
		texture = get_parent().get_node("SubViewport").get_texture()
		material = material.duplicate()
		material.set("shader_parameter/resolution", texture.get_size())
