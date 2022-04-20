extends "res://EnemyEntity.gd"

onready var myTimer = preload("res://the_Timer.tscn")

func _ready():
	
	myVisionRange.monitoring = true
	
	mySprite.scale.x = 1.5
	mySprite.scale.y = 1.5
	
	mySprite.play("idle_left")
	
	speed = 75

func _physics_process(_delta):
	if(canAttack == true):
		return
	else:
		if(currentTarget != null):
			targetPosition = currentTarget.position
		updateMovement()
	

func updateMovement():
	if(tracking == true):
		velocity = (targetPosition - position).normalized() * speed
		var angle = rad2deg(position.angle_to(velocity))
		
		assert(velocity != null)
		assert(angle != null)
		
		# If their is distance between target position and current position
		if(targetPosition - position).length() >= 0.25:
			directionX = targetPosition.x - position.x
			directionY = targetPosition.y - position.y
			
			# Play the animation for the direction it needs to head most
			# If the direction is right and is more than Y, animation X left
			if directionX > 0:
				mySprite.play("right_walk")
			
			# If the direction is left and is more than Y, animation X left
			if directionX < 0:
				mySprite.play("left_walk")
			
			velocity = move_and_slide(velocity)
			
			
			
	
	
func _on_VisionRange_body_entered(body):
	currentTarget = body
	targetPosition = body.position
	tracking = true
	speed = 75
	
func _on_VisionRange_body_exited(body):
	if(mySprite.get_animation() == "left_walk"):
		mySprite.play("idle_left")
	elif(mySprite.get_animation() == "right_walk"):
		mySprite.play("idle_right")
	
	tracking = false
	
func _on_AggroRange_body_entered(body):
	targetPosition = position
	tracking = false
	mySprite.stop()
	
	if(mySprite.get_animation() == "left_walk"):
		mySprite.play("left_attack")
	if(mySprite.get_animation() == "right_walk"):
		mySprite.play("right_attack")
		
	canAttack = true
	
func _on_AggroRange_body_exited(body):
	tracking = true
	canAttack = false
	mySprite.stop()
	
	directionX = currentTarget.position.x - position.x
	
	# Play the animation for the direction it needs to head most
	# If the direction is right and is more than Y, animation X left
	if directionX > 0:
		mySprite.play("right_walk")
			
	# If the direction is left and is more than Y, animation X left
	elif directionX < 0:
		mySprite.play("left_walk")
	
func _on_AnimatedSprite_animation_finished():
	if(mySprite.get_animation() == "left_attack" || mySprite.get_animation() == "right_attack"):
		if(canAttack == false):
			targetPosition = currentTarget.position
			tracking = true
	
	
	
