extends Node

var Enemy = preload("res://the_Slime.tscn")
onready var slime = Enemy.instance()
onready var Player = get_node("Player")

signal enemyAgro

func _ready():
	Player.position = get_node("Player").get_node("Start").position
	
	add_child(slime)
	
	slime.position = Vector2(700, 300)
	Player.position = Vector2(300, 300)
	
	
	

