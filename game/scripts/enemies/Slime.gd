extends "res://scripts/enemies/EnemyEntity.gd"


func _ready():
	myVisionRange.monitoring = true
	
	mySprite.scale.x = 3.0
	mySprite.scale.y = 3.0
	mySprite.play("down")
	
	speed = 50

func _physics_process(_delta):
	frameCount += 1
	
	if(frameCount == 20):
		frameCount = 0
		if(currentTarget != null):
			targetPosition = currentTarget.position
	
	updateMovement()
	

func updateMovement():
	
	if(tracking == true):
		var mainVector = (targetPosition - position).normalized() * speed
		var angle = rad2deg(position.angle_to(mainVector))
		
		assert(velocity != null)
		assert(angle != null)
		
		# If their is distance between target position and current position
		if(targetPosition - position).length() >= 25:
			directionX = targetPosition.x - position.x
			directionY = targetPosition.y - position.y
			
			# If its the first frame of a new loop
			if(mySprite.get_frame() == 0):
				# Play the animation for the direction it needs to head most
				# If the direction is right and is more than Y, animation X left
				if directionX > 0 && (abs(directionX)) > (abs(directionY)):
					mySprite.play("right")
			
				# If the direction is left and is more than Y, animation X left
				if directionX < 0 && (abs(directionX)) > (abs(directionY)):
					mySprite.play("left")
			
				# If the direction is down and is more than X, animation Y down
				if directionY > 0 && (abs(directionY)) > (abs(directionX)):
					mySprite.play("down")
			
				# If the direction is up and is more than X, animation Y up
				if directionY < 0 && (abs(directionY)) > (abs(directionX)):
					mySprite.play("up")
					
					
				var newVector = Vector2(cos(angle - 45), sin(angle - 45))
				
				velocity = newVector.normalized() * speed
			
			
			if(mySprite.get_frame() == 0):
				var newVector = Vector2(cos(angle - 45), sin(angle - 45))
				
				velocity = newVector.normalized() * speed
			
			
			
			if(mySprite.get_frame() == 2):
				var newVector = Vector2(cos(angle + 45), sin(angle + 45))
				
				velocity = newVector.normalized() * speed
			
			
			
			if(mySprite.get_frame() == 3):
				var newVector = Vector2(cos(angle + 45), sin(angle + 45))
				
				velocity = newVector.normalized() * speed
			
			
			velocity = move_and_slide(velocity)
			
			
		# When the target position is reached by the enemy
			if((targetPosition - position).length() < 25 && tracking == true):
				position.y = (position.y - 8)
				tracking = false
				mySprite.play("explode")
				
	
	
func _on_VisionRange_body_entered(body):
	currentTarget = body
	targetPosition = body.position
	tracking = true
	
func _on_VisionRange_body_exited(body):
	tracking = false
	
	
func _on_AnimatedSprite_animation_finished():
	if mySprite.get_animation() == "explode":
		enemyDeath()
