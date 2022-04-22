extends Node

var Slime = preload("res://scenes/enemies/the_Slime.tscn")


func spawnTheEnemy(specificEnemy, positionX, positionY):
	if(specificEnemy == "slime"):
		var slime = Slime.instance()
		add_child(slime)
		slime.global_position = Vector2(positionX, positionY)
