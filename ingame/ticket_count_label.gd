extends Label


func _physics_process(_delta: float) -> void:
	text = "TIX: %d" % ScoreManager.tickets
