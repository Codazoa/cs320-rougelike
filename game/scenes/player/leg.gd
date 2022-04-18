extends Node2D

export var offset = false
export var left = false

onready var leg = $base
onready var target = $base/target
onready var restPos = $restPos
onready var forePos = $forePos
onready var backPos = $backPos

var is_stepping = true
var is_resting = false

var speed = 200



# Called when the node enters the scene tree for the first time.
func _ready():
	target.position = restPos.position
	if !left:
		leg.left = false
		leg.make_right()
		restPos.position.y = -restPos.position.y
		backPos.position.y = -backPos.position.y
		forePos.position.y = -forePos.position.y

func step(delta):
	print(target.position)
	print(restPos.global_position)
	if is_resting:
		target.position = target.position.move_toward(restPos.global_position, delta*speed)
	elif is_stepping:

		if target.position != forePos.global_position:
			target.position = target.position.move_toward(forePos.global_position, delta*speed)
		else:
			is_stepping = false
			
	else:
		if target.position.y > 50:
			is_stepping = true
	
	
func _physics_process(delta):
	step(delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
