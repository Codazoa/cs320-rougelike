extends Node

onready var Enemy = preload("res://Snake.tscn")
onready var snake = Enemy.instance()
onready var Player = get_node("Player")

signal enemyAgro

func _ready():
	Player.position = get_node("Player").get_node("Start").position
	
	add_child(snake)
	
	snake.position = Vector2(700, 300)
	Player.position = Vector2(300, 300)
	
	
	

