extends KinematicBody2D

onready var head_sprite = $Sprite
onready var playerChar = get_node("../..")
onready var right_arm_slot = $rightArmSlot
onready var left_arm_slot = $leftArmSlot

export var color = Color(255,255,255)

#change sprite color
func recolor():
	head_sprite.modulate = color
	
#head and children follow the position of the mouse
func _physics_process(delta):
	if !playerChar.in_static:
		look_at(get_global_mouse_position())
	else:
		look_at(Vector2(global_position.x, global_position.y + 150))
