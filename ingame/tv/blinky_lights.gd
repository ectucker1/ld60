extends Node2D

var tv: TV

var lights = []

var next_blink := 0.5

var dark_color = Color("201b11")

func _ready() -> void:
	tv = get_parent()
	lights = get_children()

func _physics_process(delta: float) -> void:
	if not tv.started:
		modulate = dark_color
	else:
		modulate = Color.WHITE
	
	next_blink -= delta
	if next_blink < 0:
		for light in lights:
			if light.self_modulate == Color.WHITE:
				light.self_modulate = dark_color
				next_blink = randf_range(0.4, 0.9)
			else:
				light.self_modulate = Color.WHITE
				next_blink = randf_range(2.5, 3.9)
