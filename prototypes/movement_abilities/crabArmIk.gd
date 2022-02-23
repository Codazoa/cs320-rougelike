extends Position2D
 
const MIN_DIST = 10

onready var elbow = $elbow
onready var wrist = $elbow/wrist
onready var tip = $elbow/wrist/tip

var len_bi = 0
var len_claw = 0
var len_wrist = 0

export var left = true
export var right_offset = 4

onready var target = $target

#sets up the sprites of the arm depending on whether it is attached right or left.
func recolor(color):
	$CrabArmBi.modulate = color
	elbow.get_node("CrabArmClawA").modulate = color
	wrist.get_node("CrabArmClawB").modulate = color

#refactors certain specificat
func make_right():
	$CrabArmBi.flip_v = true
	elbow.get_node("CrabArmClawA").flip_v = true
	wrist.get_node("CrabArmClawB").flip_v = true		
		#get_node("CrabArmBi").position = get_node("CrabArmBi").position.y += right_el_offset
	elbow.get_node("CrabArmClawA").position.y += right_offset
	wrist.get_node("CrabArmClawB").position.y += -right_offset
	
func _ready():
	len_bi = elbow.position.x
	len_claw = wrist.position.x
	len_wrist = tip.position.x

	if !left:
		make_right()
		
#currently follows mouse movement for testing
func _process(delta):

	update_ik(target.position)

#This function updates the angles of the joints depending on the position of the target
#Adapted from a inverse kinematics tutorial on youtube.
#meaning I followed a tutorial for another project and implemented it myself for this one
#though there is probably alot of similarity

func update_ik(target_pos):
	#Offset gives the angle and distance between target and base
	var offset = target_pos - global_position
	var dis_to_tar = offset.length()
	if dis_to_tar < MIN_DIST:
		offset = (offset / dis_to_tar) * MIN_DIST
		dis_to_tar = MIN_DIST

	var base_r = offset.angle()
	var len_total = len_bi + len_claw + len_wrist
	
	var bend_threshold = 1.2
	var dist_ratio = dis_to_tar / len_total
	
	var len_dummy_side = (len_bi + len_claw) * clamp(dist_ratio, 0.0, 1)
 
	var base_angles = SSS_calc(len_dummy_side, len_wrist, dis_to_tar)
	var dummy_angles = SSS_calc(len_bi, len_claw, len_dummy_side)
	
	var wrist_increase = -curve(dist_ratio)*PI/4
	if left:
		wrist_increase = -wrist_increase
 
	global_rotation = (base_angles.B + dummy_angles.B + base_r)
	elbow.rotation = (dummy_angles.C)
	wrist.rotation = (base_angles.C + dummy_angles.A + wrist_increase) 

# returns all angles in a triangle based on Side-side-side calculation
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
 
#returns angle using law of cosine
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( ((a * a) + (b * b) - (c * c)) / ( 2 * (a * b)) )

#very simple bell curve calculation, used to increase claw angle based on extension of the arm
func curve(x):
	var offset = 0.5
	var width = 100 / 1 
	return clamp(pow(1.1, (-width * pow((x-offset),2))),0,1)
