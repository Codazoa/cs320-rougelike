extends Position2D
 
const MIN_DIST = 10

onready var elbow = $elbow
onready var wrist = $elbow/wrist
onready var tip = $elbow/wrist/tip

onready var rest = $rest
onready var wind = $wind
onready var hit = $hit

var cur_tar = rest

var len_upper = 0
var len_middle = 0
var len_lower = 0

export var left = true
export var right_offset = 4


var goal_pos = Vector2()
var int_pos = Vector2()
var start_pos = Vector2()
var swipe_height = 40
var swipe_rate = 0.5
var swipe_time = 0.0

func _ready():
	len_upper = elbow.position.x
	len_middle = wrist.position.x
	len_lower = tip.position.x
 
	if !left:
		$CrabArmBi.flip_v = true
		elbow.get_node("CrabArmClawA").flip_v = true
		wrist.get_node("CrabArmClawB").flip_v = true
		
		#get_node("CrabArmBi").position = get_node("CrabArmBi").position.y += right_el_offset
		elbow.get_node("CrabArmClawA").position.y += right_offset
		wrist.get_node("CrabArmClawB").position.y += -right_offset
		
		rest.position.y = -rest.position.y 
		wind.position.y = -wind.position.y 
		hit.position.y = -hit.position.y 

func move(g_pos):
	if goal_pos == g_pos:
		return

	goal_pos = g_pos
	var tip_pos = tip.global_position

	var highest = goal_pos.y
	if tip_pos.y < highest:
		highest = tip_pos.y

	var mid = (goal_pos.x + tip_pos.x) / 2.0
	start_pos = tip_pos
	int_pos = Vector2(mid, highest - swipe_height)
	swipe_time = 0.0
#
func _process(delta):
#	swipe_time += delta
#	var target_pos = Vector2()
#	var t = swipe_time / swipe_rate
#	if t < 0.5:
#		target_pos = start_pos.linear_interpolate(int_pos, t / 0.5)
#	elif t < 1.0:
#		target_pos = int_pos.linear_interpolate(goal_pos, (t - 0.5) / 0.5)
#	else:
#		target_pos = goal_pos
	update_ik(get_global_mouse_position())

func update_ik(target_pos):
	var offset = target_pos - global_position
	var dis_to_tar = offset.length()
	if dis_to_tar < MIN_DIST:
		offset = (offset / dis_to_tar) * MIN_DIST
		dis_to_tar = MIN_DIST

	var base_r = offset.angle()
	var len_total = len_upper + len_middle + len_lower
	
	var bend_threshold = 1.2
	var dist_ratio = dis_to_tar / len_total
	
	var len_dummy_side = (len_upper + len_middle) * clamp(dist_ratio, 0.0, 1)
 
	var base_angles = SSS_calc(len_dummy_side, len_lower, dis_to_tar)
	var next_angles = SSS_calc(len_upper, len_middle, len_dummy_side)
	
	var wrist_increase = - curve(dist_ratio)*PI/4
	if left:
		wrist_increase = -wrist_increase
 
	global_rotation = (base_angles.B + next_angles.B + base_r)
	elbow.rotation = (next_angles.C)
	wrist.rotation = (base_angles.C * bend_threshold + next_angles.A) 
		
func SSS_calc(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return {"A": 0, "B": 0, "C": 0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = PI - angle_a - angle_b
 
	if left:
		angle_a = -angle_a
		angle_b = -angle_b
		angle_c = -angle_c
 
	return {"A": angle_a, "B": angle_b, "C": angle_c}
 
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( (a * a + b * b - c * c) / ( 2 * a * b) )

func curve(x):
	var offset = 0.5
	var width = 100 / 1 
	return clamp(pow(1.1, (-width * pow((x-offset),2))),0,1)
