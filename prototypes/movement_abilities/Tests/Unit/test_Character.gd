extends 'res://addons/gut/test.gd'

var Player = load("res://Player.gd")
var MeleeAttachment = load("res://MeleeAttachment.gd")
var CrabArmIK = load("res://crabArmIK.gd")

#func test_take_damage():
#	var _player = Player.new()
#	_player.health = 100
#	var result = _player.take_damage(20)
#
#	assert_eq(_player.health, 80, "Result should be 90")
#	_player.free()
#
#
#func test_take_damage_not_below_zero():
#	var _player = Player.new()
#	_player.health = 10
#	_player.take_damage(50)
#
#	assert_eq(_player.health, 0, "Health should never go below zero")
#	_player.free()


#func test_is_in_range():
#	var _melee_attachment = MeleeAttachment.new()
#	var pos1 = Position2D
#	var pos2 = Position2D
#
#	pos1.x = 1
#	pos1.y = 1
#	pos2.x = 5
#	pos2.y = 5
#
#	assert_true(_melee_attachment.in_range(pos1, pos2, 10), "Positions [1,1] and [5,5] are within range 10" )
#	_melee_attachment.free()
#
	
func test_law_of_cos_zero():
	var _crab_arm_ik = CrabArmIK.new()

	assert_eq(_crab_arm_ik.law_of_cos(0, 0, 3), 0, "The angle of side C of length 5 should be 0 if a and b are 0")
	
	_crab_arm_ik.free()
	
func test_law_of_cos_not_zero():
	var _crab_arm_ik = CrabArmIK.new()

	assert_almost_eq(_crab_arm_ik.law_of_cos(3, 4, 5), 1.5708, 0.0001, "The angle of side C of length 5 should be 90")
	
	_crab_arm_ik.free()
