extends KinematicBody2D


signal enemy_death(dropped_part, vector_position)

export (int) var speed = 2

var velocity = Vector2()
var creature_part
var hitpoints


# Called when the node enters the scene tree for the first time.
func _ready():
	# CreaturePart to drop be a random one from the database
	# TO-DO: Make this more random (i.e. shuffle, track last)
	#creature_part = PartDatabase.parts.values()[randi() % PartDatabase.parts.size()]
	creature_part = PartDatabase.parts["basic_eyeball"]
	hitpoints = randi() % 20
	
	get_movement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity)
	# move_and_collide returns a collision obj which we can obtain info from
	if collision:
		_on_body_entered(collision)


func get_movement():
	velocity = Vector2()
	
	# Get random direction
	var xDirection = randi() % 2
	var yDirection = randi() % 2
	
	# Randomly make that direction pos or neg
	if randi() % 2 == 1:
		xDirection = -xDirection
	if randi() % 2 == 1:
		yDirection = -yDirection
	
	velocity.x += xDirection
	velocity.y += yDirection
	velocity = velocity.normalized() * speed


func _on_body_entered(body):
	if body.collider.name == "Player":
		hitpoints -= 5
		print(hitpoints)
	if hitpoints <= 0:
		emit_signal("enemy_death", creature_part, get_global_position())
		queue_free()
		
	# Use the normal of the collision to reverse the velocity of the enemy
	velocity = velocity.bounce(body.normal)


# Function calls get_movement() every 3 seconds to allow for time to move
# in a given direction before changing
func _on_MovementTimer_timeout():
	get_movement()
	return
