class_name BonusCornerPerWallHit
extends Disc

@export
var buff_amount := 0.0

var bounces = 0

func reset() -> void:
	bounces = 0

func on_this_wall_hit(this: TVContext, score: ScoreContext) -> void:
	bounces += 1

func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	score.corner_score_add += (buff_amount * bounces)
	bounces = 0
