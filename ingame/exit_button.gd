extends Button


func _ready() -> void:
	if OS.get_name() == "Web":
		visible = false

func _pressed() -> void:
	get_tree().quit()
