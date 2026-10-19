extends Sprite2D


var reflections: Array[Sprite2D] = []


func _physics_process(delta: float) -> void:
	var logos = get_tree().get_nodes_in_group("logos")
	
	while len(logos) > len(reflections):
		var sprite = Sprite2D.new()
		sprite.texture = preload("res://ingame/logo/logo_reflection.png")
		sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.3)
		add_child(sprite)
		reflections.push_back(sprite)
	
	for i in range(0, len(logos)):
		var logo = logos[i]
		var reflection = reflections[i]
		reflection.modulate = logo.modulate
		reflection.global_position = Vector2(3, 2) + logo.tv.global_position + logo.position - logo.tv.get_global_center()
	
	for i in range(len(logos), len(reflections)):
		reflections[i].visible = false
