extends KinematicBody2D

#head and children follow the position of the mouse
func _physics_process(delta):
	look_at(get_global_mouse_position())

