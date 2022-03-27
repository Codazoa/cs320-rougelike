extends KinematicBody2D

var velocity = Vector2.ZERO

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
	curSeg.look_at(target.position)
	if curSeg.position.distance_to(target.position) > dist:
		curSeg.position = curSeg.position.move_toward(target.position, delta*200)

#update for 3 body segments
func _physics_process(delta):
	followSeg(body, playerPos, 40,  delta)
	followSeg(tailBase, body, 25, delta)
	followSeg(tailTip, tailBase, 15,  delta)

