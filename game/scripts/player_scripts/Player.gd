extends Node2D

onready var playerPos = get_node("PlayerPos")
onready var body =  get_node("body")
onready var tailBase = get_node("tail1")
onready var tailTip = get_node("tail2")

export var health = 100
export var in_static = false

var static_toggle = BUTTON_MIDDLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func take_damage(amount):
#	health -= amount
#
#	if health < 0:
#		health = 0


func go_static():
	in_static = true
	body.position = Vector2(playerPos.position.x, playerPos.position.y - 40) 
	body.rotation = 1.52
	tailBase.position = Vector2(playerPos.position.x, playerPos.position.y - 65)
	tailBase.rotation = 1.52
	tailTip.position = Vector2(playerPos.position.x, playerPos.position.y - 80)  
	tailTip.rotation = 1.52
	
func exit_static():
	in_static = false
	
func _process(delta):
	
	if Input.is_mouse_button_pressed(static_toggle):
		if in_static:
			exit_static()
		else:
			go_static()
