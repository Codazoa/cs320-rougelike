extends Node

onready var testSlime = preload("res://enemyScenes/Slime/the_Slime.tscn")

func _ready():
	var Slime = testSlime.instance()
	
	add_child(Slime)
	
	var pos = Vector2(300, 300)
	
	Slime.position = pos
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
