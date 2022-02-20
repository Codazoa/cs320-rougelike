extends KinematicBody2D

"""
In case you're wondering why this is called peeper instead of player, 
the player sprite I used was taken from a side project/game I've been making.
Its got a bossfight named "lil'peeper", who is a giant eyeball. Hence me deciding
to name it peeper.
"""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ACCELERATION = 500;
const MAX_SPEED = 80;
const FRICTION = 500;


var velocity = Vector2.ZERO

"""
_physics_process() is modified to handle player input, as well as support wall collisions.
Additional functionality is included to allow for triggering roomShifters.
"""
func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A));
	input_vector.y = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W));
	input_vector = input_vector.normalized();
	
	if(input_vector != Vector2.ZERO):
		velocity = velocity.move_toward(input_vector*MAX_SPEED, ACCELERATION * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		
	var _result = move_and_slide(velocity);
	
	#Handle collisions
	for i in get_slide_count():
		var collision = get_slide_collision(i);
		if(collision.collider.name == "roomShifter_hitbox"):
			collision.collider.handleCollision(self);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
