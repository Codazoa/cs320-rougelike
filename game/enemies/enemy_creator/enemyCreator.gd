extends Node

#	Enemy Creator
#
#	The goal of this class is to create and enemy entity, and
#	modify the default settings to a particular type of enemy
#	specified
#

onready var Enemy = find_node("EnemyEntity")
onready var enemy 


func _ready():
	enemy = Enemy.instance()

func setEnemy(enemyType : String):
	if(enemyType == "grunt"):
		enemy.speed *= (1.25)
		enemy.health *= (0.75)
		enemy.attack *= (0.75)
	if(enemyType == "bulky"):
		enemy.speed *= (0.5)
		enemy.health *= (2.0)
		enemy.attack *= (1.0)
	if(enemyType == "speedy"):
		enemy.speed *= (1.5)
		enemy.health *= (0.5)
		enemy.attack *= (0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
