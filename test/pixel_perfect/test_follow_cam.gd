extends EffectsCamera2D

@export
var target: Node2D

func _ready() -> void:
	# The camera must not inherit the target's transform
	top_level = true
	# Update after the target
	if target:
		process_physics_priority = target.process_physics_priority + 1

func _physics_process(_delta: float) -> void:
	if not target:
		return
	# Round the same way the renderer snaps canvas items
	global_position = (target.global_position + Vector2(0.5, 0.5)).floor()
