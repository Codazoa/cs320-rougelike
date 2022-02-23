extends Node2D

onready var arm = $ClawArm

export var color = Color(0.8, 0.3, 0.3)
export var left = true

onready var rest_pos = $restPos
onready var wind_pos = $windPos
onready var target_pos = $targetPos

export var active_button = BUTTON_LEFT

export var is_resting = false
export var is_winding = false
export var is_attacking = false

export var wind_speed = 50

export var attack_speed = 300

export var base_damage = 100
export var damage_mod = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	arm.recolor(color)

	if !left:
		active_button = BUTTON_RIGHT
		arm.left = false
		arm.make_right()
		rest_pos.position.y = -rest_pos.position.y
		wind_pos.position.y = -wind_pos.position.y
		target_pos.position.y = -target_pos.position.y
		
	is_resting = true

#moves claw into windup position

func windup(delta):
	if is_winding:
		if (arm.target.position != wind_pos.position):
			arm.target.position = arm.target.position.move_toward(wind_pos.global_position, delta*wind_speed)
		

func attack(delta):
	var cur_pos = arm.target.position
	var hit_pos = target_pos.global_position
	if is_attacking:
		if (arm.target.position != target_pos.global_position):
			arm.target.position = arm.target.position.move_toward(target_pos.global_position, delta*attack_speed)
		else:
			is_attacking = false
			is_resting = true

func calc_damage():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_resting:
		if arm.target.position != rest_pos.global_position:
			arm.target.position = arm.target.position.move_toward(rest_pos.global_position, delta*200)
	if is_winding:
		if arm.target.position != wind_pos.global_position:
			arm.target.position = arm.target.position.move_toward(wind_pos.global_position, delta*200)

	if Input.is_mouse_button_pressed(active_button): 
		is_resting = false
		is_winding = true
		is_attacking = true
	else:
		is_winding = false
	
	windup(delta)
	
	if !is_winding:
		attack(delta)
	#if Input.is_mouse_button_released(active_button):
	
	
func in_range(pos1, pos2, prox):
	var x_thresh = pos2.x - pos1.x
	var y_thresh = pos2.y - pos1.y
	print (x_thresh, y_thresh)
	if abs(x_thresh) <= prox && abs(y_thresh) <= prox:
		return true
	else:
		return false
	
