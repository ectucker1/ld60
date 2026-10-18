@tool
extends Sprite2D


## Corner hit scores in this range scale from the smallest to the wildest static burst
@export var burst_score_min := 25
@export var burst_score_max := 300
## How much of the burst the smallest hit still gets (0 to 1), so every corner flickers a little
@export_range(0.0, 1.0) var burst_floor := 0.15
## Seconds for the smallest (x) and biggest (y) bursts to settle back to normal
@export var burst_decay_time := Vector2(0.3, 1.2)

@export_group("Burst peaks")
## Amounts added on top of the material's own settings at the peak of the biggest burst
@export var peak_static_noise := 0.6
@export var peak_noise_opacity := 0.7
@export var peak_distort := 0.15
@export var peak_aberration := 0.5
@export var peak_roll_speed := 10.0
## Brightness flash, which fades out faster than the rest of the burst
@export var peak_brightness := 0.8


const BURST_PARAMS := ["static_noise_intensity", "noise_opacity", "distort_intensity", "aberration", "roll_speed", "brightness"]

var _base := {}
var _peak := 0.0
# How much of the current burst is left, from 1 down to 0
var _burst := 0.0
var _flash := 0.0
var _decay_time := 1.0


func _ready() -> void:
	if not Engine.is_editor_hint():
		texture = get_parent().get_node("SubViewport").get_texture()
		material = material.duplicate()
		material.set("shader_parameter/resolution", texture.get_size())
		for param in BURST_PARAMS:
			_base[param] = material.get_shader_parameter(param)

## Kicks the screen static up, wilder the bigger the corner score
func corner_burst(score: int) -> void:
	var t := clampf(inverse_lerp(float(burst_score_min), float(burst_score_max), float(score)), 0.0, 1.0)
	var strength := lerpf(burst_floor, 1.0, t)
	# A small hit never cuts short a bigger burst that is still settling
	if strength >= _peak * _burst * _burst:
		_peak = strength
		_burst = 1.0
		_decay_time = lerpf(burst_decay_time.x, burst_decay_time.y, t)
	_flash = maxf(_flash, strength)

func _process(delta: float) -> void:
	if Engine.is_editor_hint() or (_burst <= 0.0 and _flash <= 0.0):
		return

	_burst = maxf(0.0, _burst - delta / _decay_time)
	_flash = maxf(0.0, _flash - 4.0 * delta)
	# Squared so the burst drops off quickly at first, then lingers as a faint shimmer
	var amount := _peak * _burst * _burst

	material.set_shader_parameter("static_noise_intensity", _base.static_noise_intensity + peak_static_noise * amount)
	material.set_shader_parameter("noise_opacity", minf(1.0, _base.noise_opacity + peak_noise_opacity * amount))
	material.set_shader_parameter("distort_intensity", _base.distort_intensity + peak_distort * amount)
	material.set_shader_parameter("aberration", _base.aberration + peak_aberration * amount)
	material.set_shader_parameter("roll_speed", _base.roll_speed + peak_roll_speed * amount)
	material.set_shader_parameter("brightness", _base.brightness + peak_brightness * _flash)
