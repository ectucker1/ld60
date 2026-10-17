class_name Disc
extends Resource


## Name of the disc
@export
var name := "REPLACE_ME"

## Text shown in the tooltip for the disc
@export
var desc := "REPLACE_ME"

## The number of these discs which should be available in the shop pool
@export
var num_in_pool := 0

## The type of disc that two of this disc can combine to, if any.
@export
var combine_to: Disc

## Multiplier to the base speed added by the disc
@export
var speed_mult := 0.0

## Flat amount added to the scoring of walls, before the multiplier
## Score = base_wall_value + sum(wall_score_add) * sum(wall_score_mult)
@export
var wall_score_add := 0

## Multiplier added to scoring of walls
## Score = base_wall_value + sum(wall_score_add) * sum(wall_score_mult)
@export
var wall_score_mult := 0.0

## Flat amount to scoring of corners, before the multiplier
## Score = base_corner_value + sum(corner_score_add) * sum(corner_score_mult)
@export
var corner_score_add := 0

## Multiplier added to scoring of corners
## Score = base_corner_value + sum(corner_score_add) * sum(corner_score_mult)
@export
var corner_score_mult := 0.0

## Called when a disc in this TV changes color.
## Return the color it should change to instead.
func on_color_change(this: TVContext, target_color: Color) -> Color:
	return target_color

## Called whenever a wall on this disc's TV is hit.
## This can modify ScoreContext if it wants to do something.
func on_this_wall_hit(this: TVContext, score: ScoreContext) -> void:
	pass

## Called whenever a wall on a _different_ TV is hit.
## This can modify ScoreContext if it wants to do something.
func on_other_wall_hit(this: TVContext, score: ScoreContext) -> void:
	pass

## Called whenever a corner on this disc's TV is hit.
## This can modify ScoreContext if it wants to do something.
func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	pass

## Called whenever a corner on a _different_ TV is hit.
## This can modify ScoreContext if it wants to do something.
func on_other_corner_hit(this: TVContext, score: ScoreContext) -> void:
	pass

## Called each physics_process.
func on_physics_process(tv: TVContext, delta: float) -> void:
	pass

## Called after everthing else has been applied to a score context.
## Do effects here that might want to use scored points as a threshold.
func finalize_score_context(this: TVContext, score: ScoreContext) -> void:
	pass
