extends Node2D


var disc: PackedScene = preload("res://ingame/disc/disc.tscn")

var pool: Array[Disc]


func consume_disc_folder(discs: Array[Disc], dir: String):
	for path in ResourceLoader.list_directory(dir):
		if path.ends_with("/"):
			consume_disc_folder(discs, dir + "/" + path)
		if path.ends_with(".tres"):
			var disc = load(dir + "/" + path)
			if disc is Disc:
				discs.append(disc)


func _ready() -> void:
	var discs: Array[Disc] = []
	consume_disc_folder(discs, "res://ingame/disc/disc_types")
	
	pool = []
	for disc in discs:
		for i in range(0, disc.num_in_pool):
			pool.push_back(disc)

func can_refresh() -> bool:
	var num_bought = 0
	for marker in $Markers.get_children():
		if marker.get_child_count() == 0:
			num_bought += 1
	return num_bought >= 2

func refresh() -> void:
	# Add remaining back to pool
	for marker in $Markers.get_children():
		for child in marker.get_children():
			if child is DiscDisplay:
				var original_disc = load(child.disc.get_meta("original_path"))
				pool.push_back(original_disc)
			child.queue_free()
	
	# Spawn new discs
	pool.shuffle()
	for marker in $Markers.get_children():
		if pool.is_empty():
			continue
		
		var new_disc = disc.instantiate()
		new_disc.disc = pool.pop_back()
		marker.add_child(new_disc)
		new_disc.global_position = marker.global_position
