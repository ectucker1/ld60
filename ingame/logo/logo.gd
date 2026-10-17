extends CharacterBody2D


@export
var speed := 50.0

var direction := Vector2.RIGHT


func _ready() -> void:
	randomize()
	var angle = randf() * TAU
	direction = Vector2.RIGHT.rotated(angle)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	if collision != null:
		direction = -direction.reflect(collision.get_normal())
