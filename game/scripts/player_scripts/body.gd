extends KinematicBody2D

var velocity = Vector2.ZERO

onready var playerChar = get_node("..")
onready var playerPos = get_node("../PlayerPos")
onready var body =  get_node("../body")
onready var tailBase = get_node("../tail1")
onready var tailTip = get_node("../tail2")

export var color = Color(255,255,255)

#Body segments follow their target
func recolor():
	body.get_node("Sprite").modulate = color
	tailBase.get_node("Sprite").modulate = color
	tailTip.get_node("Sprite").modulate = color

func followSeg(curSeg: KinematicBody2D, target:KinematicBody2D, dist: int, delta):
	curSeg.look_at(target.global_position)
	if curSeg.global_position.distance_to(target.global_position) > dist:
		curSeg.global_position = curSeg.global_position.move_toward(target.global_position, delta*500)

#update for 3 body segments
func _physics_process(delta):
	if !playerChar.in_static: 
		followSeg(body, playerPos, 40 * playerChar.scale.y,  delta)
		followSeg(tailBase, body, 25 * playerChar.scale.y, delta)
		followSeg(tailTip, tailBase, 15 * playerChar.scale.y ,  delta)

