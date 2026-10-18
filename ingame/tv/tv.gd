@tool
class_name TV
extends Area2D


@export
var world_size: Vector2i = Vector2i(16, 9):
	set(value):
		world_size = value
		if is_node_ready():
			$SubViewport.world_size = world_size
		notify_property_list_changed()

@export
var left: TV
@export
var right: TV
@export
var above: TV
@export
var below: TV

@export
var unlock_at := 1000

# Context describing this TV.
# Will be initialized in tv_connector.gd
var context: TVContext

var connector: TVConnector


var slots: Array[DiscSlot] = []

var started := false
var logo_scene := preload("res://ingame/logo/logo.tscn")

var point_scene := preload("res://ingame/popup/point_popup.tscn")

class TempBuff:
	var disc: Disc
	var time_left: float
	
	func _init(disc: Disc, time: float) -> void:
		self.disc = disc
		self.time_left = time

var temp_buffs: Array[TempBuff]
var temp_buffs_to_add: Array[TempBuff]


func _ready() -> void:
	$SubViewport.world_size = world_size
	for node in $Slots.get_children():
		if node is DiscSlot:
			slots.push_back(node)
	connector = get_parent()
	$Sprite2D.visible = false

func _mouse_enter() -> void:
	if not started:
		TooltipManager.try_show(self)

func _mouse_exit() -> void:
	TooltipManager.try_remove(self)

func get_discs() -> Array[Disc]:
	var result: Array[Disc] = []
	for slot in slots:
		if slot.inserted_disc != null and slot.inserted_disc.disc != null:
			result.push_back(slot.inserted_disc.disc)
	for buff in temp_buffs:
		result.push_back(buff.disc)
	return result

func get_speed_mult() -> float:
	var mult = 1.0
	for disc in get_discs():
		mult += disc.speed_mult
	return mult

# Called every time a logo on this TV hits an edge
func hit_edge(logo: CharacterBody2D) -> void:
	var score_context = ScoreContext.new()
	score_context.source_tv = context
	score_context.color = logo.modulate
	score_context.wall_score_add += 1
	score_context.wall_score_mult = 1.0
	
	for disc in get_discs():
		score_context.wall_score_add += disc.wall_score_add
		score_context.wall_score_mult += disc.wall_score_mult
		disc.on_this_wall_hit(context, score_context)
	
	connector.on_wall_hit(self, score_context)
	
	var score = score_context.get_wall_score()
	ScoreManager.score += score
	
	var point_display = point_scene.instantiate()
	add_child(point_display)
	point_display.position = logo.global_position - Vector2(world_size.x, world_size.y) / 2
	point_display.set_score(score)

# Called every time a logo on this TV hits a corner
func hit_corner(logo: CharacterBody2D) -> void:
	var score_context = ScoreContext.new()
	score_context.source_tv = context
	score_context.color = logo.modulate
	score_context.corner_score_add += 25
	score_context.corner_score_mult = 1.0
	
	for disc in get_discs():
		score_context.corner_score_add += disc.corner_score_add
		score_context.corner_score_mult += disc.corner_score_mult
		disc.on_this_corner_hit(context, score_context)
	
	connector.on_corner_hit(self, score_context)
	
	var score = score_context.get_corner_score()
	ScoreManager.score += score
	
	var point_display = point_scene.instantiate()
	add_child(point_display)
	point_display.position = logo.global_position - Vector2(world_size.x, world_size.y) / 2
	point_display.set_score(score)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	DebugOverlay.add_message(self, "%s Speed" % name, "%f" % get_speed_mult())
	
	if ScoreManager.score >= unlock_at and not started:
		# Start the TV and spawn the logo!
		started = true
		$Sprite2D.visible = true
		var logo = logo_scene.instantiate()
		$SubViewport/InsideTVWorld.add_child(logo)
		logo.global_position = Vector2(float(world_size.x) / 2, float(world_size.y) / 2)

	
	$CenterContainer/UnlockProgress.value = 100.0 * float(ScoreManager.score) / unlock_at
	$CenterContainer/UnlockProgress.visible = !started
	
	# Downtick duration of buffs
	var to_remove = []
	for buff in temp_buffs:
		buff.time_left -= delta
		if buff.time_left <= 0:
			to_remove.push_back(buff)
	# Erase expired buffs
	for buff in to_remove:
		temp_buffs.erase(buff)
	# Add new buffs
	for buff in temp_buffs_to_add:
		temp_buffs.push_back(buff)
	temp_buffs_to_add.clear()
	
	for disc in get_discs():
		disc.on_physics_process(context, delta)

## Queue a hit in a corner to happen shortly in the future
## Just a placeholder for now
func queue_corner_hit() -> void:
	pass

## Add a temporary buff to this TV, which lasts for the given duration
func add_temp_buff(buff: Disc, duration: float) -> void:
	temp_buffs_to_add.push_back(TempBuff.new(buff, duration))
