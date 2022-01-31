extends KinematicBody2D
const max_dist  = 40

var velocity = Vector2.ZERO

onready var target = get_node("../PlayerPos")

func _physics_process(delta):
	look_at(target.position)
	
	if position.distance_to(target.position) > 40:
		print("too far")
		position = position.move_toward(target.position, delta*200)
