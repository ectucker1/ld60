extends Area2D


var overlapping_disc


func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)


func _area_entered(area: Area2D) -> void:
	if area is DiscDisplay:
		overlapping_disc = area

func _area_exited(area: Area2D) -> void:
	if overlapping_disc == area:
		overlapping_disc = null

func _physics_process(delta: float) -> void:
	if overlapping_disc != null and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if DragManager.dragged_object == overlapping_disc:
			DragManager.dragged_object = null
		overlapping_disc.queue_free()
		overlapping_disc = null
