class_name SpeedUpAdjacentDisc
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

func on_physics_process(this: TVContext, delta: float) -> void:
	if above and this.above != null:
		var buff = Disc.new()
		buff.speed_mult = buff_amount
		this.above.tv.add_temp_buff(buff, delta)
	if below and this.below != null:
		var buff = Disc.new()
		buff.speed_mult = buff_amount
		this.below.tv.add_temp_buff(buff, delta)
	if left and this.left != null:
		var buff = Disc.new()
		buff.speed_mult = buff_amount
		this.left.tv.add_temp_buff(buff, delta)
	if right and this.right != null:
		var buff = Disc.new()
		buff.speed_mult = buff_amount
		this.right.tv.add_temp_buff(buff, delta)
