class_name DoubleOnEvenDisc
extends Disc

func finalize_score_context(this: TVContext, score: ScoreContext) -> void:
	if score.get_score() % 2 == 0:
		score.wall_score_mult *= 2
		score.corner_score_mult *= 2
	else:
		score.wall_score_mult = 0
		score.corner_score_mult = 0
