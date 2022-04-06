extends Node2D

onready var arm = $ClawArm

export var color = Color(0.8, 0.3, 0.3)
export var left = false

onready var rest_pos = $restPos
onready var wind_pos = $windPos
onready var target_pos = $targetPos

onready var hitbox = $Hitbox
onready var hitdetector = $Hitbox/HitDetector
var hit_move = Vector2.ZERO

export var active_button = BUTTON_LEFT

var is_resting = false
var is_winding = false
var is_attacking = false

export var wind_speed = 50

export var attack_speed = 300

export var base_damage = 50
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
	
	hitdetector.disabled = true
	is_resting = true

#moves claw into windup position
func windup(delta):
	if is_winding:
		if (arm.target.position != wind_pos.position):
			arm.target.position = arm.target.position.move_toward(wind_pos.global_position, delta*wind_speed)

#plays attack animation and activates hitbox
func attack(delta):
	hitdetector.disabled = false
	var cur_pos = arm.target.position
	var hit_pos = target_pos.global_position

	hitbox.global_position = cur_pos
	if is_attacking:
		if (arm.target.position != target_pos.global_position):
			arm.target.position = arm.target.position.move_toward(target_pos.global_position, delta*attack_speed)
		else:
			is_attacking = false
			hitdetector.disabled = true
			is_resting = true

func calc_damage():
	pass
	
	
func _on_targetDetection_body_entered(body):
	
	if body.is_in_group("enemy"):
		print("target in rage")
		target_pos = body.global_position
		
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

#checks if position is in given range
func in_range(pos1, pos2, prox):
	var x_thresh = pos2.position.x - pos1.position.x
	var y_thresh = pos2.position.y - pos1.position.y
	print (x_thresh, y_thresh)
	if abs(x_thresh) <= prox && abs(y_thresh) <= prox:
		return true
	else:
		return false
	

