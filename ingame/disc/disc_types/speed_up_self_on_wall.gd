class_name SpeedUpSelfOnWall
extends Disc

@export
var buff_amount := 0.0

var bounces = 0

func reset() -> void:
	bounces = 0

func on_this_wall_hit(this: TVContext, score: ScoreContext) -> void:
	bounces += 1

func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	bounces = 0

func on_physics_process(this: TVContext, delta: float) -> void:
	var buff = Disc.new()
	buff.speed_mult = 0 + (0.1 * bounces)
	this.tv.add_temp_buff(buff, delta)
