extends KinematicBody2D

#	Enemy Entity
#
#	The goal of this script is to create a default enemy character,
#	creating its base animations, stats, and other mechanics that
#	can be changed or modified later. Its the base object
#

onready var mySprite = $KinematicBody2D/Sprite
onready var myHitbox = $KinematicBody2D/Hitbox
onready var defaultTexture = preload("res://enemyAssets/subAssets/Centipede.png")

var isMoving = false

var speed = 200
var health = 100
var attack = 10

func _ready():
	mySprite.texture = defaultTexture
	mySprite.visible = true
	mySprite.position = Vector2(0,0)

func _physics_process(delta):
	if(isMoving == true):
		pass
		
		
		


