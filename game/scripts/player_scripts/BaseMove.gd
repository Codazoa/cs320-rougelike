extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 150
const FRICTION  = 500

const ROT_SPEED  = 1

var velocity = Vector2.ZERO
onready var playerChar = get_node("..")


onready var body =  get_node("../body")
onready var tailBase = get_node("../tail1")
onready var tailTip = get_node("../tail2")

export (NodePath) var head

func rebuild_body():
	body.position = Vector2(position.x, position.y - 40) 
	tailBase.position = Vector2(position.x, position.y - 65)
	tailTip.position = Vector2(position.x, position.y - 80)  
	
#player character moves based on WASD input
#based on tutorial code i used when first learning godot
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector =  input_vector.normalized()
	
# COMMENTED OUT IT IS MY OLD CODE, EVERYTHING BELOW THE COMMENTS IS SYDNEY'S
#	if input_vector != Vector2.ZERO:
#		velocity += input_vector * ACCELERATION * delta 
#		velocity = velocity.clamped(MAX_SPEED * delta)
#		rotation = input_vector.angle()
#
#	else:
#		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

#	SYDNEY'S CODE
	if(input_vector != Vector2.ZERO):
		velocity = velocity.move_toward(input_vector*MAX_SPEED, ACCELERATION * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
	move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i);
		if(collision.collider.name == "roomShifter_hitbox"):
			collision.collider.handleCollision(self);
