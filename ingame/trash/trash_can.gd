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

var prev_pressed := false

func _physics_process(delta: float) -> void:
	if overlapping_disc != null and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) != prev_pressed:
		if DragManager.dragged_object == overlapping_disc:
			DragManager.dragged_object = null
		overlapping_disc.queue_free()
		overlapping_disc = null
		GlobalSounds.play("Trashcan")
	prev_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
