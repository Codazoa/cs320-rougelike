extends Node2D

onready var cannon = $Cannon
onready var arm = $base
onready var slime_spawn = cannon.get_node("BallSpawn")

export var color = Color(0.8, 0.3, 0.3)
export var left = false

onready var rest_pos = $restPos
onready var knock_pos = $knockPos

export var active_button = BUTTON_LEFT

export var is_charging =  false
export var is_resting = false

export var knock_speed = 200

func recolor(color):
	$Cannon.modulate = color
	arm.get_node("GunArmBi").modulate = color
	
	
func make_right():
	active_button = BUTTON_RIGHT
	cannon.get_node("GunArmCannonA").flip_h = true
	cannon.get_node("GunArmCannonB").flip_h = true
	arm.get_node("GunArmBi").flip_h
	cannon.position.x = -cannon.position.x
	rest_pos.position.x = -rest_pos.position.x
	knock_pos.position.x = -knock_pos.position.x
# Called when the node enters the scene tree for the first time.
func _ready():
	recolor(color)
	if !left:
		make_right()
		
func fire(delta):
	var cur_pos = cannon.position
	var target_pos = knock_pos.position

	if is_resting:
		target_pos = rest_pos.position
	cannon.position = cannon.position.move_toward(target_pos, delta*knock_speed)
	if cannon.position == knock_pos.position:
		is_resting = true
	
func _physics_process(delta):
	arm.look_at(cannon.global_position)
	cannon.look_at(get_global_mouse_position())

	if Input.is_mouse_button_pressed(active_button):
		is_charging = true
		is_resting = false
		cannon.get_node("GunProjectile").visible = true
	else:
		if is_charging:
			fire(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
