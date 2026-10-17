class_name TVConnector
extends Node2D


var all_tvs: Array[TV] = []


func _ready() -> void:
	for node in get_children():
		if node is TV:
			node.context = TVContext.new()
			all_tvs.push_back(node)
	
	for node in get_children():
		if node is TV:
			if node.left != null:
				node.context.left = node.left.context
			if node.right != null:
				node.context.right = node.right.context
			if node.below != null:
				node.context.below = node.below.context
			if node.above != null:
				node.context.above = node.above.context

func on_wall_hit(source: TV, score_context: ScoreContext):
	for tv in all_tvs:
		if tv != source:
			for disc in tv.get_discs():
				disc.on_other_wall_hit(tv.context, score_context)

func on_corner_hit(source: TV, score_context: ScoreContext):
	for tv in all_tvs:
		if tv != source:
			for disc in tv.get_discs():
				disc.on_other_corner_hit(tv.context, score_context)
