extends Node


var score: int = -25

var tickets: int = 0

var last_ticket: int = 0
var next_ticket: int = 25

func ticket_progress() -> float:
	return float(score - last_ticket) / float(next_ticket - last_ticket) * 100.0

func _physics_process(delta: float) -> void:
	if score > next_ticket:
		tickets += 1
		var next_next_ticket = next_ticket_threshold(next_ticket)
		last_ticket = next_ticket
		next_ticket = next_next_ticket

func next_ticket_threshold(prev_ticket: int) -> int:
	return ( (prev_ticket * 1.15) + (40 * log(prev_ticket) / log(10)) + 30 )
 
