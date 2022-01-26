extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

signal updatePosition

var velocity = Vector2.ZERO
var speed = 100

var targetPosition
var directionX 
var directionY 
var track = false

func _physics_process(_delta):
	if track:
		emit_signal("updatePosition")
		
		velocity = (targetPosition - position).normalized() * speed
		
		if (targetPosition - position).length() > 0.5:
			# If the target position is
			directionX = targetPosition.x - position.x
			directionY = targetPosition.y - position.y
			
			# If the direction is right and is more than Y, animation X left
			if directionX > 0 && (abs(directionX)) > (abs(directionY)):
				animatedSprite.play("rightWalk")
			
			# If the direction is left and is more than Y, animation X left
			if directionX < 0 && (abs(directionX)) > (abs(directionY)):
				animatedSprite.play("leftWalk")
			
			# If the direction is down and is more than X, animation Y down
			if directionY > 0 && (abs(directionY)) > (abs(directionX)):
				animatedSprite.play("downWalk")
			
			# If the direction is up and is more than X, animation Y up
			if directionY < 0 && (abs(directionY)) > (abs(directionX)):
				animatedSprite.play("upWalk")
			
			velocity = move_and_slide(velocity)
		else:
			position = targetPosition
			animatedSprite.set_frame(0)
			animatedSprite.stop()
		
func update_position(value):
	targetPosition = value
	
func _on_MainScene_enemyAgro(value):
	targetPosition = value

func _on_Player_found():
	track = true

func _on_Player_hidden():
	track = false
	animatedSprite.set_frame(0)
	animatedSprite.stop()
