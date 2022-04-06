extends KinematicBody2D

var damage = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	damage = get_parent().base_damage * get_parent().damage_mod
	print(damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	position = get_parent().arm
