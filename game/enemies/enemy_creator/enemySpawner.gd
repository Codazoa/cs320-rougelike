extends Node

#	Enemy Spawner:
#
#	The purpose of this class is to specify the type of enemy you want,
#	as well as a specific location you want the spawn that enemy at
#

onready var Enemy = find_node("EnemyCreator")

func spawnEnemy(positionX: int, positionY: int, enemyType: String):
	var enemy = Enemy.instace()

	
	
	