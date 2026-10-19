extends Button


@export var set_high_speed := false

func _pressed() -> void:
	# Settings for next run
	ReplayManager.is_fast_mode = set_high_speed
	ReplayManager.skip_main_menu = true
	
	## Reset all the numbers
	ScoreManager.competitor_time_current = 0.0
	ScoreManager.competitor_score = 0
	ScoreManager.score = -999
	ScoreManager.tickets = 0
	ScoreManager.last_ticket = 0
	ScoreManager.next_ticket = 25
	ScoreManager.its_over = false
	ScoreManager.total_earnings_highscore = 0

	# Clear tooltips and dragging
	TooltipManager.current = null
	TooltipManager.next = null
	TooltipManager.next_time = 0.0
	DragManager.dragged_object = null
	
	# Reload scene
	PixelPerfect.reload_current_scene()
	
	# Start game in 0.2 seconds
	get_tree().create_timer(0.2).timeout.connect(func(): ScoreManager.score = 0)
