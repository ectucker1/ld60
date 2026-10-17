class_name TriggerRight
extends Disc

#on corner hit, give bonus to next corner on tv to the right
func on_this_corner_hit(this: TVContext, score: ScoreContext) -> void:
	var tv_right = this.right
	if(tv_right):
		#tell the tv to the right an effect FIX ME
		return;
