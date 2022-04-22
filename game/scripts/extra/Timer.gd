 extends Timer

onready var timerEnded = false

func startTimer(time):
	start(time)

func _on_the_Timer_timeout():
	timerEnded = true
