extends Node

#	Enemy Creator
#
#	The goal of this class is to create and enemy entity, and
#	modify the default settings to a particular type of enemy
#	specified
#

onready var Enemy = find_node("EnemyEntity")

onready var currentAnimation = $Enemy/AnimatedSprite
onready var theHitBox = $Enemy/HitBox
onready var theAgrroRange = $Enemy/AggroRange 

signal health_gone

var enemy
var preSet = false

func _ready():
	enemy = Enemy.instance()
	
	add_child(enemy)

func setEnemy(enemyType : String):
	if(preSet == false):
		if(enemyType == "grunt"):
			enemy.speed *= (1.25)
			enemy.health *= (0.75)
			enemy.attack *= (0.75)
			enemy.defense *= (0.75)
			
			preSet = true
		
		if(enemyType == "bulky"):
			enemy.speed *= (0.5)
			enemy.health *= (2.0)
			enemy.attack *= (1.0)
			enemy.defense *= (1.5)
			
			preSet = true
			enemy.hasWeakness = true
		
		if(enemyType == "speedy"):
			enemy.speed *= (1.5)
			enemy.health *= (0.5)
			enemy.attack *= (0.5)
			enemy.defense *= (0.5)
			
			preSet = true
			
		else:
			pass
			
			
			
func updateMax(maxX : int, maxY : int):
	enemy.maxBoundsX = maxX
	enemy.maxBoundsY = maxY



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
