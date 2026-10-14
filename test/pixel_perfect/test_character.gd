extends CharacterBody2D


@export
var speed: float = 100.0

@export
var shake_interval: float = 2.0

@export_range(0.0, 1.0)
var shake_trauma: float = 0.25


var _shake_timer := 0.0


func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _process(delta: float) -> void:
	if shake_interval <= 0.0:
		return
	_shake_timer += delta
	if _shake_timer >= shake_interval:
		_shake_timer -= shake_interval
		CameraEffects.add_trauma(shake_trauma)

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input.length() > 0.3:
		# Snap analog input to 8 directions
		input = Vector2.from_angle(snappedf(input.angle(), PI / 4)).round().normalized()
		if input.x != 0.0 and input.y != 0.0:
			# On diagonals, snap the per-axis speed so pixel steps land on an even rhythm
			# Whole pixels per tick, or one pixel every whole number of ticks
			var axis_step := absf(input.x) * speed * delta
			axis_step = roundf(axis_step) if axis_step >= 1.0 else 1.0 / roundf(1.0 / axis_step)
			input = input.sign() * axis_step / (speed * delta)
	else:
		input = Vector2.ZERO
	velocity = input * speed
	move_and_slide()
