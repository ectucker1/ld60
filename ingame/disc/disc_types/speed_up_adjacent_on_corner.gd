class_name SpeedUpAdjacentDiscOnCorner
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

@export
var buff_time = 1.0

var time = 0

func reset() -> void:
	time = 0

func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	time = buff_time

func on_physics_process(this: TVContext, delta: float) -> void:
	time = time - delta
	if(time < 0):
		return
	var buff_calc = buff_amount
	if(time < 1):
		buff_calc = buff_amount * time

	if above and this.above != null:
		var buff = Disc.new()
		buff.speed_mult = buff_calc
		this.above.tv.add_temp_buff(buff, delta)
	if below and this.below != null:
		var buff = Disc.new()
		buff.speed_mult = buff_calc
		this.below.tv.add_temp_buff(buff, delta)
	if left and this.left != null:
		var buff = Disc.new()
		buff.speed_mult = buff_calc
		this.left.tv.add_temp_buff(buff, delta)
	if right and this.right != null:
		var buff = Disc.new()
		buff.speed_mult = buff_calc
		this.right.tv.add_temp_buff(buff, delta)
