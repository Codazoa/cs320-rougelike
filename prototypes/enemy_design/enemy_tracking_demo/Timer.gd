extends Timer

onready var timerEnded = false

func startTimer(time):
	start(time)
	timerEnded = false

func _on_the_Timer_timeout():
	timerEnded = true
