extends Node

#should be between 10 and 15k
var crash_threshold: int = 15000

var competitor_time_base: float = 0.2
var competitor_time_current: float = 0.0

var competitor_score: int = 0

var score: int = 0

#default back to zero after testing!!!!!!!
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
	if score > crash_threshold:
		competitor_time_current -= delta
		if(competitor_time_current < 0):
			competitor_time_current = competitor_time_base
			competitor_score = (competitor_score * 1.00001) + 41
			print(competitor_score)
func next_ticket_threshold(prev_ticket: int) -> int:
	return ( (prev_ticket * 1.09) + (25 * log(prev_ticket) / log(10)) + 100 )
 	#Balance return point sunday morning
	#return ( (prev_ticket * 1.125) + (42 * log(prev_ticket) / log(10)) + 30 )
 
