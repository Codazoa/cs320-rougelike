extends Position2D
const MIN_DIST = 10

onready var knee = $knee
onready var tip = $knee/tip

onready var target = $target

export var left = true

var len_upper = 0
var len_lower = 0

func recolor(color):
	modulate = color

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func make_right():
	
	get_node("leg_upper").flip_v = true
	knee.get_node("leg_lower").flip_v = true

# Called when the node enters the scene tree for the first time.
func _ready():
	len_upper = knee.position.x
	len_lower = tip.position.x
	if !left:
		make_right()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _process(delta):
	update_ik(target.position)
	
func update_ik(target_pos):
	var offset = target_pos - global_position
	var dis_to_tar = offset.length()
	
	if dis_to_tar < MIN_DIST:
		offset = (offset / dis_to_tar) * MIN_DIST
		dis_to_tar = MIN_DIST
	
	var base_r = offset.angle()
	var len_total = len_upper + len_lower 
	
	var knee_angle = SSS_calc(len_upper, len_lower, dis_to_tar)
	
	global_rotation = (knee_angle.A + base_r)
	knee.rotation = (knee_angle.C)


## MATH FUNCTIONS COPIED FROM CLAW ARM IK
# returns all angles in a triangle based on Side-side-side calculation
func SSS_calc(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return {"A": 0, "B": 0, "C": 0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = PI - angle_a - angle_b
 
	if !left:
		angle_a = -angle_a
		angle_b = -angle_b
		angle_c = -angle_c
 
	return {"A": angle_a, "B": angle_b, "C": angle_c}
 
#returns angle using law of cosine
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( ((a * a) + (b * b) - (c * c)) / ( 2 * (a * b)) )
