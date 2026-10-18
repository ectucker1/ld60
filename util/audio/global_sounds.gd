extends Node
## Global pool of sound effects


## Corner hit scores in this range scale from the smallest to the most explosive hit
@export var corner_score_min := 25
@export var corner_score_max := 100
## Volume (dB) added on top of CornerHit's own volume, for the smallest (x) and biggest (y) hits
@export var corner_volume_range := Vector2(-3.0, 4.0)
## Pitch for the smallest (x) and biggest (y) hits, lower sounds heavier
@export var corner_pitch_range := Vector2(1.05, 0.85)
## How far into the score range (0 to 1) the octave-down boom layer starts fading in
@export_range(0.0, 1.0) var corner_boom_start := 0.4
## Volume (dB) of the boom layer at the biggest hits, relative to CornerHit's own volume
@export var corner_boom_volume := -2.0

## How far the TVs' static is pitched apart, spread from the first TV (down) to the last (up)
@export var tv_static_pitch_spread := 0.06


# When true, triggers of new sounds are disabled
var pause_triggers: bool = false


@onready var _corner_hit: AudioStreamPlayer = $CornerHit
@onready var _corner_base_volume := _corner_hit.volume_db
var _corner_boom: AudioStreamPlayer
@onready var _tv_static: AudioStreamPlayer = $TVStatic


func _ready() -> void:
	# The boom layer is the same sound played an octave down, under big hits
	_corner_boom = _corner_hit.duplicate()
	_corner_boom.name = "CornerHitBoom"
	add_child(_corner_boom)


func play(sound: NodePath) -> void:
	if pause_triggers:
		return

	var stream = get_node(sound)
	if AudioStreamCollection.is_stream(stream):
		stream.play()


## Plays the corner hit, louder, heavier and with a low boom the bigger the score
func play_corner_hit(score: int) -> void:
	if pause_triggers:
		return

	var t := clampf(inverse_lerp(float(corner_score_min), float(corner_score_max), float(score)), 0.0, 1.0)
	_corner_hit.volume_db = _corner_base_volume + lerpf(corner_volume_range.x, corner_volume_range.y, t)
	_corner_hit.pitch_scale = lerpf(corner_pitch_range.x, corner_pitch_range.y, t)
	_corner_hit.play()

	if t > corner_boom_start:
		var boom_t := inverse_lerp(corner_boom_start, 1.0, t)
		_corner_boom.volume_db = _corner_base_volume + corner_boom_volume + linear_to_db(boom_t)
		_corner_boom.pitch_scale = _corner_hit.pitch_scale * 0.5
		_corner_boom.play()


## Starts a looping copy of TVStatic on the given TV, pitched by where it sits among the TVs
func start_tv_static(tv: TV) -> void:
	var tvs := tv.get_parent().get_children().filter(func(node): return node is TV)
	var t := float(tvs.find(tv)) / maxi(1, tvs.size() - 1)

	var player: AudioStreamPlayer = _tv_static.duplicate()
	player.pitch_scale = 1.0 + lerpf(-tv_static_pitch_spread, tv_static_pitch_spread, t)
	tv.add_child(player)
	# Start each TV at a random point in the loop so they don't line up
	player.play(randf() * player.stream.get_length())
