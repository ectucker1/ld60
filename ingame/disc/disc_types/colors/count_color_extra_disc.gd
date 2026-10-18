class_name CountColorExtraDisc
extends Disc


@export
var target_color: Color

@export
var extra_add := 0


#func on_this_wall_hit(this: TVContext, score: ScoreContext) -> void:
	#if score.color == target_color:
		#score.wall_score_add += extra_add

func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	if score.color == target_color:
		score.corner_score_add += extra_add
