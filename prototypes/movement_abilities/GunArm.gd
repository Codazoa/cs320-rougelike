extends Node2D
const KNOCK_SPEED = 200
onready var cannon = $Cannon
onready var arm = $base
onready var slime_view = $Cannon/GunProjectile
onready var slime_spawn = cannon.get_node("BallSpawn")

export var color = Color(0.8, 0.3, 0.3)
export var slime_color = Color(1, 1, 1)

export var left = false

onready var rest_pos = $restPos
onready var knock_pos = $knockPos

var world_scene = Node

export (PackedScene) var slime_inst
export var active_button = BUTTON_LEFT
export var slime_speed = 15

var is_charging =  false
var is_resting = false
var is_loaded = true

func recolor(color):
	cannon.get_node("GunArmCannonA").modulate = color
	cannon.get_node("GunArmCannonB").modulate = color
	arm.get_node("GunArmBi").modulate = color
	slime_view.modulate = slime_color
	
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
	world_scene = get_tree().get_root().get_node("World")	
	
	slime_view.visible = true
	recolor(color)
	
	if !left:
		make_right()
		
func fire(delta):
	var slime_ball = slime_inst.instance()
	if is_loaded:
		is_charging = false
		is_loaded = false
		world_scene.add_child(slime_ball)
		slime_ball.position = slime_spawn.global_position
		slime_ball.recolor(slime_color)
		slime_ball.shoot(get_angle_to(get_global_mouse_position()), slime_speed)
		
		slime_view.visible = false
				
		var timer = Timer.new()
		self.add_child(timer)
		timer.connect("timeout", self, "reload")
		timer.set_wait_time(0.5)
		timer.start()
	
	knockback(delta)

func knockback(delta):
	var cur_pos = cannon.position
	var target_pos = knock_pos.position
	
	if is_resting:
		target_pos = rest_pos.position
	cannon.position = cannon.position.move_toward(target_pos, delta*KNOCK_SPEED)
	if cannon.position == knock_pos.position:
		is_resting = true
		
func reload():
	is_loaded = true
	slime_view.visible = true

func _physics_process(delta):
	arm.look_at(cannon.global_position)
	cannon.look_at(get_global_mouse_position())

	if Input.is_mouse_button_pressed(active_button):
		is_charging = true
		is_resting = false		
	else:
		if is_charging:
			fire(delta)

	
