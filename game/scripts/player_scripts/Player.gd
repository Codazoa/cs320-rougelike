extends Node2D

export var health = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(amount):
	health -= amount
	
	if health < 0:
		health = 0
