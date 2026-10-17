extends TextureProgressBar


func _process(delta: float) -> void:
	value = ScoreManager.ticket_progress()
