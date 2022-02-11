extends Node

onready var Enemy = get_node("Enemy")
onready var Player = get_node("Player")

signal enemyAgro

func _ready():
	Player.position = get_node("Player").get_node("Start").position
	Enemy.position = get_node("Enemy").get_node("Start").position
	

func _on_Enemy_updatePosition():
	$Enemy.update_position(Player.position)
