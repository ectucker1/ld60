extends Node


var current: Node2D

var next: Node2D
var next_time := 0.0


func try_show(maybe_next: Node2D) -> void:
	if current == null:
		next = maybe_next
		next_time = 0.0

func try_remove(maybe_next: Node2D) -> void:
	if current == maybe_next:
		current = null
	if next == maybe_next:
		next = null

func _process(delta: float) -> void:
	if next != null:
		if next_time < 0.2:
			next_time += delta
		else:
			current = next
