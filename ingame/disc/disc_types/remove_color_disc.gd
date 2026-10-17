class_name RemoveColorDisc
extends Disc

enum Channel
{
	RED, GREEN, BLUE
}

@export
var channel: Channel = Channel.RED

func on_color_change(this: TVContext, target_color: Color) -> Color:
	match channel:
		Channel.RED:
			target_color.r = 0
		Channel.GREEN:
			target_color.g = 0
		Channel.BLUE:
			target_color.b = 0
	if target_color == Color.BLACK:
		target_color = Color.WHITE
	return target_color
