class_name ScoreContext
extends RefCounted


## The TV this score is occuring on 
var source_tv: TVContext

## The color of the logo which is triggering this score
var color: Color

## Flat amount added to the scoring of walls, before the multiplier
## Score = base_wall_value + sum(wall_score_add) * sum(wall_score_mult)
var wall_score_add := 0
## Multiplier added to scoring of walls
## Score = base_wall_value + sum(wall_score_add) * sum(wall_score_mult)
var wall_score_mult := 0.0

## Flat amount to scoring of corners, before the multiplier
## Score = base_corner_value + sum(corner_score_add) * sum(corner_score_mult)
var corner_score_add := 0
## Multiplier added to scoring of corners
## Score = base_corner_value + sum(corner_score_add) * sum(corner_score_mult)
var corner_score_mult := 0.0

## True if this score is on a left wall or corner
var is_left := false
## True if this score is on a right wall or corner
var is_right := false
## True if this score is on a bottom wall or corner
var is_bottom := false
## True if this score is on a top wall or corner
var is_top := false

func get_wall_score() -> int:
	return max(0, roundi(wall_score_add * wall_score_mult))

func get_corner_score() -> int:
	return max(0, roundi(corner_score_add * corner_score_mult))
