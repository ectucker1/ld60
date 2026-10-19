extends Node2D


var disc: PackedScene = preload("res://ingame/disc/disc.tscn")

var initial_pool: Array[Disc]
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
	
	initial_pool = []
	for disc in discs:
		for i in range(0, disc.num_in_pool):
			initial_pool.push_back(disc)
	
	pool = []
	for disc in initial_pool:
		pool.push_back(disc)

func can_refresh() -> bool:
	var num_bought = 0
	for marker in $Markers.get_children():
		if marker.get_child_count() == 0:
			num_bought += 1
	return num_bought >= 2

var force_unique_every = 4
var force_unique_in = force_unique_every

func refresh() -> void:
	# Add remaining back to pool
	for marker in $Markers.get_children():
		for child in marker.get_children():
			if child is DiscDisplay:
				var original_disc = load(child.disc.get_meta("original_path"))
				pool.push_back(original_disc)
			child.queue_free()
	
	force_unique_in -= 1
	
	# Spawn new discs
	pool.shuffle()
	for marker in $Markers.get_children():
		# Re-add discs to pool if it is empty
		if pool.is_empty():
			for disc in initial_pool:
				pool.push_back(disc)
			pool.shuffle()
		
		# Force a unique, if available
		var chosen_disc = null
		if force_unique_in <= 0:
			for disc in pool:
				if disc.tier == 4:
					chosen_disc = disc
		if chosen_disc != null:
			pool.erase(chosen_disc)
		else:
			chosen_disc = pool.pop_back()
		if chosen_disc.tier == 4:
			force_unique_in = force_unique_every
		
		var new_disc = disc.instantiate()
		new_disc.disc = chosen_disc
		marker.add_child(new_disc)
		new_disc.global_position = marker.global_position
