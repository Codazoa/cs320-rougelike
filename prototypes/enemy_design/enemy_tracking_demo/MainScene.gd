extends Node

onready var Enemy = preload("res://the_Snake.tscn")
onready var Player = get_node("Player")

signal enemyAgro

func _ready():
	Player.position = get_node("Player").get_node("Start").position
	var snake = Enemy.instance()
	
	add_child(snake)
	
	snake.mySprite.play("idle_left")
	snake.speed = 75
	
	snake.position = Vector2(710, 310)
	Player.position = Vector2(300, 300)
	
	
	

