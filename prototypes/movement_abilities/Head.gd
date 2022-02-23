extends KinematicBody2D

onready var head_sprite = $Sprite

onready var right_arm_slot = $rightArmSlot
onready var left_arm_slot = $leftArmSlot

export var color = Color(255,255,255)

#head and children follow the position of the mouse
func recolor():
	head_sprite.modulate = color
	
func _physics_process(delta):
	look_at(get_global_mouse_position())

