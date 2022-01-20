extends RigidBody2D

export var min_speed = 150
export var max_speed = 250


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "spin"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
