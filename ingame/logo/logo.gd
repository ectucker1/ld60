extends CharacterBody2D


@export
var base_speed := 50.0


var tv: TV

var direction := Vector2.RIGHT


func find_tv(node) -> TV:
	if node is TV:
		return node
	else:
		return find_tv(node.get_parent())

func _ready() -> void:
	tv = find_tv(self)
	randomize()
	var angle = randf() * TAU
	direction = Vector2.RIGHT.rotated(angle)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * base_speed * tv.get_speed_mult() * delta)
	if collision != null:
		direction = -direction.reflect(collision.get_normal())
