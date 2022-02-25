extends Node

#	Enemy Spawner:
#
#	The purpose of this class is to specify the type of enemy you want,
#	as well as a specific location you want the spawn that enemy at
#

onready var Enemy = find_node("EnemyCreator")

func spawnEnemy(positionX: int, maxX: int, positionY: int, maxY: int, enemyType: String):
	var enemy = Enemy.instace()
	
	assert(enemyType != null)
	
	enemy.setEnemy(enemyType)
	
	enemy.position = Vector2(positionX, positionY)
	
	enemy.updateMax(maxX, maxY)
	
	add_child(enemy)
	
	
	
	
