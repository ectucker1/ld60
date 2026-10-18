class_name NoCornerDoubleWallDisc
extends Disc


func finalize_score_context(this: TVContext, score: ScoreContext) -> void:
	match score.type:
		ScoreContext.ScoreType.WALL:
			score.wall_score_mult += 1.0
		ScoreContext.ScoreType.CORNER:
			score.corner_score_mult = 0.0
