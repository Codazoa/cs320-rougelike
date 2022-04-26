extends KinematicBody2D


######################################################################
#	Enemy Entity
#
#	The goal of this script is to create a default enemy character,
#	creating its base animations, stats, and other mechanics that
#	can be changed or modified later. Its the base object
#
######################################################################
#
#	The Following written by Dylan Strong
#
######################################################################

signal updatePosition

onready var mySprite = $AnimatedSprite
onready var myHitbox = $HitBox
onready var myAggroRange = $AggroRange
onready var myAttackPoint = $AttackPoint
onready var myVisionRange = $VisionRange

onready var myAggroShape = $AggroRange/AggroShape
onready var myAttackRange = $AttackPoint/AttackRange
onready var myVisionShape = $VisionRange/VisionShape

# Booleans

var isVisible = true
var tracking = false
var hasWeakness = false
var canAttack = false


# Calculating Variables

onready var screen_size = get_viewport_rect().size

var velocity = Vector2.ZERO 

var angle = 0

var maxBoundsX = 0
var maxBoundsY = 0

var frameCount = 0
var currentTarget

var targetPosition = Vector2(0,0)
var directionX
var directionY

# Enemy Stats

var speed = 200
var health = 100
var attack = 10
var defense = 5
var modi = 1.0

func _ready():	
	targetPosition = 0
	directionX = 0
	directionY = 0
	visible = true
	tracking = false
	

func _physics_process(_delta):
	
	if mySprite.get_animation() == "Attack":
		return
	
	updateMovement()
	
	
func updateMovement():
	if(tracking == true):
		velocity = (targetPosition - position).normalized() * speed
		
		assert(velocity != null)
		
		# If their is distance between target position and current position
		if(targetPosition - position).length() > 0:
			directionX = targetPosition.x - position.x
			directionY = targetPosition.y - position.y
			
			# Double checking Direction X/Y for errors
			assert(directionX != null)
			assert(directionY != null)
			
			# If the direction is right and is more than Y, animation X left
			if directionX > 0 && (abs(directionX)) > (abs(directionY)):
				if mySprite != null:
					mySprite.play("right")
				
				#myAttackRange.rotate = 0
				#myAttackRange.position.x = 0
				
			# If the direction is left and is more than Y, animation X left
			if directionX < 0 && (abs(directionX)) > (abs(directionY)):
				if mySprite != null:
					mySprite.play("left")
				
				#myAttackRange.rotate = 0
				#myAttackRange.position.x = -20
				
			
			# If the direction is down and is more than X, animation Y down
			if directionY > 0 && (abs(directionY)) > (abs(directionX)):
				if mySprite != null:
					mySprite.play("down")
				
				#myAttackRange.rotate = 90
				#myAttackRange.position.y = 20
				
				
			# If the direction is up and is more than X, animation Y up
			if directionY < 0 && (abs(directionY)) > (abs(directionX)):
				if mySprite != null:
					mySprite.play("up")
				
				#myAttackRange.rotate = 90
				#myAttackRange.position.y = -20
			
			velocity = move_and_slide(velocity)
			
		# When the target position is reached by the enemy
		else:
			position = targetPosition
			if mySprite != null:
				mySprite.set_frame(0)
				mySprite.stop()
			
			
func onEnemyHit(playerAttack : int):
	var damageDealt = 0
	if playerAttack <= 0:
		return -1
	
	else:
		if(hasWeakness == false):
			damageDealt = ((defense) - (playerAttack*modi))
			health -= damageDealt
		
		if(hasWeakness == true):
			damageDealt = ((defense*0.5) - (playerAttack*modi))
			health = (health) - damageDealt
			
	
		assert(health != null)
	
		return damageDealt
	
	
func isAligned(givenPosition : Vector2):
	var currentPosition = position
	
	if(currentPosition.x == givenPosition.x):
		return true
	
	if(currentPosition.y == givenPosition.y):
		return true
		
	else:
		return false
		
	
func _on_AggroRange_body_entered(_body):
	mySprite.play("Attack")
	
	
func updatePosition(newVector : Vector2):
	assert(newVector != null)
	targetPosition = newVector
	
func updateModifier(newModi : float):
	assert(newModi != null)
	modi = newModi
	
func hit():
	myAttackPoint.monitoring = true
	
func endOfHit():
	myAttackPoint.monitoring = false
	
func _on_VisionRange_body_entered(_body):
	tracking = true
	
func _on_VisionRange_body_exited(_body):
	tracking = false
	

func enemyDeath():
	hide()
	isVisible = false
	emit_signal("health_gone")
	queue_free()
#	mySprite.set_frame(0)
#	mySprite.stop()

#################################################################

# Getters and Setters
# Note: Created to eventually privatize the enemy's stats

func setEnemyPosition(givenVector : Vector2):
	position = givenVector
	
func setEnemyHealth(amount : int):
	health = amount
	
func setEnemyDefense(modi : int):
	defense = defense * modi
	
func setEnemyAttack(modi : int):
	attack = attack * modi
	
func setEnemySpeed(givenSpeed : int):
	speed = givenSpeed
	
func setModi(newModi : float):
	modi = newModi
	
func getEnemyPosition():
	return position
	
func getEnemyHealth():
	return health
	
func getEnemyDefense():
	return defense
	
func getEnemyAttack():
	return attack
	
func getEnemySpeed():
	return speed
	
func getModi():
	return modi

##################################################################

