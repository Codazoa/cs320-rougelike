extends KinematicBody2D

#	Enemy Entity
#
#	The goal of this script is to create a default enemy character,
#	creating its base animations, stats, and other mechanics that
#	can be changed or modified later. Its the base object
#

onready var mySprite = $KinematicBody2D/AnimatedSprite
onready var myHitbox = $KinematicBody2D/Hitbox
onready var myAggro = $KinematicBody2D/AggroRange

onready var defaultTexture = preload("res://enemyAssets/subAssets/Centipede.png")

# Booleans

var isMoving = false
var hasWeakness = false

# Calculating Variables

var velocity = Vector2.ZERO

var targetPosition
var directionX
var directionY

# Enemy Stats

var speed = 200
var health = 100
var attack = 10
var defense = 5
var modi = 1.0

func _ready():
	mySprite.visible = true
	mySprite.position = Vector2(0,0)
	

func _physics_process(delta):
	if(isMoving == true):
		velocity = (targetPosition - mySprite.position).normalized() * speed
		
		if(targetPosition - position).length() > 0.5:
			directionX = targetPosition.x - mySprite.position.x
			directionY = targetPosition.y - mySprite.position.y
			
			# If the direction is right and is more than Y, animation X left
			if directionX > 0 && (abs(directionX)) > (abs(directionY)):
				pass
				
			# If the direction is left and is more than Y, animation X left
			if directionX < 0 && (abs(directionX)) > (abs(directionY)):
				pass
			
			# If the direction is down and is more than X, animation Y down
			if directionY > 0 && (abs(directionY)) > (abs(directionX)):
				pass
				
			# If the direction is up and is more than X, animation Y up
			if directionY < 0 && (abs(directionY)) > (abs(directionX)):
				pass
			
		# When the target position is reached by the enemy
		else:
			position = targetPosition
			
			
			
func onEnemyHit(attack : int):
	health = (health) - ((defense) - (attack*modi))
	
	if(health <= 0):
		enemyDeath()
	
	
func updatePosition(newVector : Vector2):
	targetPosition = newVector
	
func updateModifier(newModi : float):
	modi = newModi
	
	
	
func enemyDeath():
	hide()
	emit_signal("health_gone")
		
		
		
		


