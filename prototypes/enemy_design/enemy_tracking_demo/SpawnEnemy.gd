extends Node

var Slime = preload("res://the_Slime.tscn")

func spawnTheEnemy(specificEnemy, positionX, positionY):
	if(specificEnemy == "slime"):
		var slime = Slime.instance()
		add_child(slime)
		slime.position = Vector2(positionX, positionY)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
