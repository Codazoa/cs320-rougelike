extends Node2D

onready var white = get_node("White")
onready var pupil =  get_node("PupilPhys")
onready var timer =  get_node("Timer")

var view_range = 300
var eye_range = 5 * scale.x

var is_blinking = false
var opening = false
var min_eye_time = 2.0
var max_eye_time = 5.0

# Called when the node enters the scene tree for the first time.

func _ready():
	timer.set_wait_time(rand_range(min_eye_time, max_eye_time))
#	timer.start()
	
func _on_Timer_timeout():
	timer.stop()
	is_blinking = true
	
func blink():
	if !opening:
		white.scale.y = - (0.1 * scale)
		if white.scale.y < (0.1 * scale):
			opening = true
	else:
		white.scale.y = (0.1 * scale)
		if white.scale.y >= (scale):
			is_blinking = false
			opening = false
#			timer.set_wait_time(rand_range(min_eye_time, max_eye_time))
#			timer.start()
	

func _process(delta):
	print(timer.get_time_left())
	if is_blinking:
		
		blink()
		
func _physics_process(delta):
	var md = global_position.distance_to(get_global_mouse_position())
	var target_pos = get_local_mouse_position() * (eye_range/view_range)
	if md < view_range:
		pupil.position = pupil.position.move_toward(target_pos, delta * 200)



