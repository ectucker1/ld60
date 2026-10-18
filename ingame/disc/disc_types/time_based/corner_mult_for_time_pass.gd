class_name CornerMultTimePass
extends Disc

@export
var mult_bonus := 1.0

var time = 0

func reset() -> void:
	time = 0

func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	score.corner_score_mult += sqrt(time)/4 * mult_bonus -0.5
	time = 0

func on_physics_process(this: TVContext, delta: float) -> void:
	time += delta
