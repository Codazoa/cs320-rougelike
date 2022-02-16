extends KinematicBody2D

#	Enemy Entity
#
#	The goal of this script is to create a default enemy character,
#	creating its base animations, stats, and other mechanics that
#	can be changed or modified later. Its the base object
#

onready var mySprite = $Sprite

var isMoving = false

var speed = 200
var health = 100
var attack = 10

func _ready():
	pass

func _physics_process(delta):
	if(isMoving == true):
		pass

