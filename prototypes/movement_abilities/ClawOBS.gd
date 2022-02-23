#OUTDATED AND OBSOLETE CODE. was based on documentation for 2d Inverse kinematics included in Godot
#was not satisfied with results so I took a different approach seen in crabArmIK.gd

extends KinematicBody2D

var target
onready var restPos = get_node("restPos")
onready var windPos = get_node("windPos")
onready var hitPos = get_node("hitPos")

onready var skeleton = get_node("Skeleton")

onready var clawB = get_node("Skeleton2D/bi/clawA/clawB")

export var segLimit = 3

func _ready():
	target = restPos
	var tTrans = target.get_global_transform()
	remove_child(target)
	skeleton.add_child(target)
	target.set_global_transform(tTrans)
	set_process(true)
	
func pass_chain(delta):
	var b = skeleton.get_bone(clawB)
	var l = segLimit
	
	while (b >= 0 and l > 0):
		b = skeleton.get_bone_parent(b) 
		l = l - 1
	
func _process(delta):
	pass_chain(delta)

func _physics_process(delta):
	clawB.position = clawB.position.move_toward(restPos, 200*delta)
	
