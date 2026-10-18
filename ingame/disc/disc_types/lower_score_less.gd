class_name LowerScoreLess
extends Disc

@export
var above := false

@export
var below := false

@export
var left := false

@export
var right := false

@export
var buff_amount := 0.0
#FIX ME - math may be WAY off
func on_physics_process(this: TVContext, delta: float) -> void:
	var buff_calc = buff_amount * -0.5
	if above and this.above != null:
		var buff = Disc.new()
		buff.corner_score_mult = buff_calc
		buff.wall_score_mult = buff_calc
		this.above.tv.add_temp_buff(buff, delta)
	if below and this.below != null:
		var buff = Disc.new()
		buff.corner_score_mult = buff_calc
		buff.wall_score_mult = buff_calc
		this.below.tv.add_temp_buff(buff, delta)
	if left and this.left != null:
		var buff = Disc.new()
		buff.corner_score_mult = buff_calc
		buff.wall_score_mult = buff_calc
		this.left.tv.add_temp_buff(buff, delta)
	if right and this.right != null:
		var buff = Disc.new()
		buff.corner_score_mult = buff_calc
		buff.wall_score_mult = buff_calc
		this.right.tv.add_temp_buff(buff, delta)
