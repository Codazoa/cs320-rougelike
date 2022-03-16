extends KinematicBody2D

#	Enemy Entity
#
#	The goal of this script is to create a default enemy character,
#	creating its base animations, stats, and other mechanics that
#	can be changed or modified later. Its the base object
#

onready var mySprite = $AnimatedSprite
onready var myHitbox = $HitBox
onready var myAggroRange = $AggroRange
onready var myAttackPoint = $AttackPoint

onready var myAggroShape = $AggroRange/AggroShape
onready var myAttackRange = $AttackPoint/AttackRange


# Booleans

var tracking = false
var hasWeakness = false

# Calculating Variables

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

var maxBoundsX = 0
var maxBoundsY = 0

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
	
	rng.randomize()
	
	targetPosition = 0
	directionX = 0
	directionY = 0
	visible = true
	position = Vector2(0,0)
	

func _physics_process(_delta):
	
	if mySprite.get_animation() == "Attack":
		return
	
	updateMovement()
	
	
	
	
func updateMovement():
	if(tracking == true):
		velocity = (targetPosition - position).normalized() * speed
		
		assert(velocity != null)
		
		# If their is distance between target position and current position
		if(targetPosition - position).length() > 0.5:
			directionX = targetPosition.x - position.x
			directionY = targetPosition.y - position.y
			
			# Double checking Direction X/Y for errors
			assert(directionX != null)
			assert(directionY != null)
			
			# If the direction is right and is more than Y, animation X left
			if directionX > 0 && (abs(directionX)) > (abs(directionY)):
				assert(mySprite != null)
				
				mySprite.play("right")
				
				#myAttackRange.rotate = 0
				myAttackRange.position.x = 0
				
			# If the direction is left and is more than Y, animation X left
			if directionX < 0 && (abs(directionX)) > (abs(directionY)):
				assert(mySprite != null)
				
				mySprite.play("left")
				
				#myAttackRange.rotate = 0
				myAttackRange.position.x = -20
				
			
			# If the direction is down and is more than X, animation Y down
			if directionY > 0 && (abs(directionY)) > (abs(directionX)):
				assert(mySprite != null)
				
				mySprite.play("down")
				
				#myAttackRange.rotate = 90
				myAttackRange.position.y = 20
				
				
			# If the direction is up and is more than X, animation Y up
			if directionY < 0 && (abs(directionY)) > (abs(directionX)):
				assert(mySprite != null)
				
				mySprite.play("up")
				
				#myAttackRange.rotate = 90
				myAttackRange.position.y = -20
			
			velocity = move_and_slide(velocity)
			
		# When the target position is reached by the enemy
		else:
			position = targetPosition
			assert(mySprite != null)
			mySprite.set_frame(0)
			mySprite.stop()
			
			
			
			
			
func onEnemyHit(playerAttack : int):
	if(hasWeakness == false):
		health = (health) - ((defense) - (playerAttack*modi))
		
	if(hasWeakness == true):
		var numberFromRange = rng.randi_range(0, 100)
		
		assert(0 < numberFromRange < 100)
		
		if(20 < numberFromRange < 30):
			health = (health) - ((defense*0.5) - (playerAttack*modi))
	
	assert(health != null)
	
	if(health <= 0):
		enemyDeath()
	
	
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
	emit_signal("health_gone")
	mySprite.set_frame(0)
	mySprite.stop()

