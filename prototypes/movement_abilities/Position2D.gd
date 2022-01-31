extends KinematicBody2D

const ACCELERATION = 50
const MAX_SPEED = 200
const FRICTION  = 400

const ROT_SPEED  = 1

var velocity = Vector2.ZERO

onready var spr_body = $body
onready var spr_head = $head/head
onready var spr_tail1 = $Tail1/tail1
onready var spr_tail2 = $Tail1/Tail2/tail2

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector =  input_vector.normalized()
	

	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta 
		velocity = velocity.clamped(MAX_SPEED * delta)
		#print(input_vector.angle())
		#rotation = input_vector.angle()
		#print(rotation)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	move_and_collide(velocity)
