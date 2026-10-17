class_name ScoreNearbyWall
extends Disc



@export
var up : bool = false

@export 
var down : bool = false

@export 
var left : bool = false

@export 
var right : bool = false

@export
var bonus : int = 1

#on other corner hit check if its beside us and give points if so
func on_other_wall_hit(this: TVContext, score: ScoreContext) -> void:
	if(this.right and score.source_tv == this.right and right):
		ScoreManager.score += bonus
	elif(this.left and score.source_tv == this.left and left):
		ScoreManager.score += bonus
	elif(this.above and score.source_tv == this.above and up):
		ScoreManager.score += bonus
	elif(this.below and score.source_tv == this.below and down):
		ScoreManager.score += bonus
