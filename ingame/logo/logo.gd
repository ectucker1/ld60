class_name Logo
extends CharacterBody2D

#speed should be 18. set higher to test faster
@export
var base_speed := 18.0


var tv: TV

var direction := Vector2.RIGHT


var colors = [Color.WHITE, Color.RED, Color.GREEN, Color.BLUE, Color.CYAN, Color.MAGENTA, Color.YELLOW]


func find_tv(node) -> TV:
	if node is TV:
		return node
	else:
		return find_tv(node.get_parent())

func _ready() -> void:
	tv = find_tv(self)
	
	randomize()
	var angle = randf() * TAU
	direction = Vector2.RIGHT.rotated(angle)
	
	# Rig angle for the first logo
	if ScoreManager.score < 20:
		direction = Vector2(0.091, -0.18).normalized()
	
	modulate = colors.pick_random()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * base_speed * tv.get_speed_mult() * delta)
	if collision != null:
		direction = -direction.reflect(collision.get_normal())
		if collision.get_collider() is SideBody:
			tv.hit_edge(self)
			collision.get_collider().hit(collision)
			var new_color = colors.pick_random()
			for disc in tv.get_discs():
				new_color = disc.on_color_change(tv.context, new_color)
			modulate = new_color
	
	queue_redraw()

func hit_corner():
	var score = tv.hit_corner(self)
	var bend = randf() * TAU * 0.1
	direction = direction.rotated(bend)
	GlobalSounds.play_corner_hit(score)

func _draw() -> void:
	var loc = BounceLoc.new(global_position, direction)
	for i in range(0, 10):
		var next = find_next_bounce(loc.pos, loc.out_dir)
		#draw_line(to_local(loc.pos), to_local(next.pos), Color.AQUA)
		loc = BounceLoc.new(next.pos + next.out_dir * 1.0, next.out_dir)

class BounceLoc:
	var pos: Vector2
	var out_dir: Vector2
	
	func _init(pos: Vector2, out_dir: Vector2) -> void:
		self.pos = pos
		self.out_dir = out_dir

func ray_line_intersect(p: Vector2, d: Vector2, a: Vector2, b: Vector2):
	var v = b - a
	var denom = d.cross(v)
	if abs(denom) < 1e-6:
		return Vector2(INF, INF)
	var o = p - a
	var t = (a - p).cross(v) / denom
	var u = (a - p).cross(d) / denom
	var intersect = Vector2(p.x + t * d.x, p.y + t * d.y)
	return intersect

func find_next_bounce(start: Vector2, dir: Vector2) -> BounceLoc:
	var world_size: Vector2i = get_parent().world_size
	var our_size = $CollisionShape2D.shape.size
	
	var min_y = our_size.y / 2.0
	var max_y = world_size.y - min_y
	var target_y = min_y
	if dir.y > 0:
		target_y = max_y
	var min_x = our_size.x / 2.0
	var max_x = world_size.x - min_x
	var target_x = min_x
	if dir.x > 0:
		target_x = max_x
	
	var intersect_target_y = ray_line_intersect(start, dir, Vector2(-2000, target_y), Vector2(2000, target_y))
	var intersect_target_x = ray_line_intersect(start, dir, Vector2(target_x, -2000), Vector2(target_x, 2000))
	
	var target_x_dist = intersect_target_x.distance_squared_to(start)
	var target_y_dist = intersect_target_y.distance_squared_to(start)

	var target_pos = Vector2.ZERO
	var normal = Vector2.ZERO
	
	if target_x_dist < target_y_dist:
		target_pos = intersect_target_x
		normal = Vector2(0, -sign(dir.y))
	else:
		target_pos = intersect_target_y
		normal = Vector2(-sign(dir.x), 0)
	
	var out_dir = dir.reflect(normal)
	
	return BounceLoc.new(target_pos, out_dir)
