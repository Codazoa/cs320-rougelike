extends Node2D

export var offset = false
export var left = false

onready var leg = $base
onready var target = $base/target
onready var restPos = $restPos
onready var forePos = $forePos
#onready var backBoxBR = $backBoxBR
#onready var backBoxBL = $backBoxBL
#onready var backBoxTR = $backBoxTR
#onready var backBoxTL = $backBoxTL

onready var tip = $base/knee/tip

onready var slot = get_node("..")

var is_stepping = true
var is_resting = false

var step_target = null

var timer = null

var speed = 500



# Called when the node enters the scene tree for the first time.
func _ready():
	if slot.slot_num % 2 == 0:
		left = true
	if slot.slot_num in range(1,3): 
		offset = true
	step_target = forePos.global_position
	target.global_position = restPos.global_position
	if !left:
		leg.left = false
		leg.make_right()
		restPos.position.y = -restPos.position.y
#		backPos.position.y = -backPos.position.y
		forePos.position.y = -forePos.position.y
		
	timer = Timer.new()
	add_child(timer)

	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(((speed/500) * 0.5)/2)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()



#WIP
func step(delta):

	
	if is_stepping:
		step_target = forePos.global_position
		is_stepping = false
		
#	print(step_target)
#	print(forePos.global_position)
	
	if is_resting:
		target.position = target.position.move_toward(restPos.global_position, delta*speed)
	
	if step_target != null:
		target.position = target.position.move_toward(step_target, delta*speed)
	
		#This was me trying to reset step_target based on its current position, it did not work
#		var local_step = step_target - leg.global_position
#		print(step_target)
#		print(backBoxBR.global_position.y)
#		print(backBoxTL.global_position.y)
#		print(backBoxBR.global_position.x)
#		print(backBoxTL.global_position.x)
#		print(range(6.0, 4.0))
#		if int(step_target.y) in range(int(backBoxBR.global_position.y), int(backBoxTL.global_position.y)) and int(step_target.x) in range(int(backBoxBR.global_position.x), int(backBoxTL.global_position.x)):
#			print("please god")
#			is_stepping = true


#BELOW IS AN OLD IMPLEMENTATION OF STEP THAT I ENDED UP DISSATISFIED WITH THE LOOK OF
#func step(delta):
#	print(target.position)
#	print(restPos.global_position)
#	if is_resting:
#		target.position = target.position.move_toward(restPos.global_position, delta*speed)
#	elif is_stepping:
#
#		if target.position != forePos.global_position:
#			target.position = target.position.move_toward(forePos.global_position, delta*speed)
#		else:
#			is_stepping = false
#
#	else:
#		if target.position.y > 50:
#			is_stepping = true
#
	
func _physics_process(delta):
	step(delta)

func _on_Timer_timeout():
	if !offset:
		is_stepping = true
		offset = true
	else:
		offset = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


