extends 'res://addons/gut/test.gd'

var Player = load("res://Player.gd")
var MeleeAttachment = load("res://MeleeAttachment.gd")
var CrabArmIK = load("res://crabArmIK.gd")
var DamBox = load("res://DamBox.tscn")
var ClawArm = load("res://ClawArm.tscn")
var HealthDisplay = load("res://HealthDisplay.tscn")

#assertion test
func test_take_damage():
	var _player = Player.new()
	_player.health = 100
	var result = _player.take_damage(20)

	assert_eq(_player.health, 80, "Result should be 90")
	_player.free()

#assertion test
func test_take_damage_not_below_zero():
	var _player = Player.new()
	_player.health = 10
	_player.take_damage(50)

	assert_eq(_player.health, 0, "Health should never go below zero")
	_player.free()

#assertion test
func test_law_of_cos_zero():
	var _crab_arm_ik = CrabArmIK.new()

	assert_eq(_crab_arm_ik.law_of_cos(0, 0, 3), 0, "The angle of side C of length 5 should be 0 if a and b are 0")
	
	_crab_arm_ik.free()

#assertion test
func test_law_of_cos_not_zero():
	var _crab_arm_ik = CrabArmIK.new()

	assert_almost_eq(_crab_arm_ik.law_of_cos(3, 4, 5), 1.5708, 0.0001, "The angle of side C of length 5 should be 90")
	
	_crab_arm_ik.free()


#integration test	
func test_dam_box_has_healthbar():
	var _dam_box = DamBox.instance()

	var _healthbar = _dam_box.get_node("HealthDisplay")
	
	assert_not_null(_dam_box)
	assert_not_null(_healthbar)

	_dam_box.free()

#integration test
func test_update_health_on_damage():
	var _dam_box = DamBox.instance()
	self.add_child(_dam_box)

	var _healthbar = _dam_box.get_node("HealthDisplay")
	
	assert_not_null(_dam_box)
	assert_not_null(_dam_box.healthbar)
	assert_not_null(_healthbar)
	
	_dam_box.take_damage(50)
	
	assert_eq(_healthbar.healthbar.scale.x, 0.5)
	

	_dam_box.free()
	
#assertion test	
func test_arm_recolor():
	#func recolor(color):
	#	modulate = color
	var _claw = ClawArm.instance()
	
	assert_not_null(_claw)
	
	var test_color = Color(.5,.5,.5)
	
	_claw.recolor(test_color)
	
	assert_eq(_claw.modulate, test_color)
	
	_claw.free()
	
#white box tests for HealthDisplay update_health() 
	#func update_health(health):
	#	if health < 0 or health > max_value:
	#		print("invalid health input")
	#		return null
	#
	#	var ratio = float(size)*(float(health) / float(max_value))
	#	healthbar.scale.x = ratio
	#	if ratio < 0.75:
	#		healthbar.modulate = half_color
	#	if ratio < 0.35:
	#		healthbar.modulate = low_color
	
#full branch coverage across next 6 tests

#almost_eq assert used for ratios to account for float division discrepencies

func test_update_healthbar_full():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	_healthbar.update_health(100)
	
	assert_almost_eq(_healthbar.healthbar.scale.x, 1, 0.01)
	assert_eq(_healthbar.healthbar.modulate, _healthbar.full_color)
	
	_healthbar.free()
		
func test_update_healthbar_75():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	_healthbar.update_health(75)
	
	assert_almost_eq(_healthbar.healthbar.scale.x, 0.75, 0.01)
	assert_eq(_healthbar.healthbar.modulate, _healthbar.full_color)
	
	_healthbar.free()
	
func test_update_healthbar_35():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	_healthbar.update_health(35)
	
	assert_almost_eq(_healthbar.healthbar.scale.x, 0.35, 0.01)
	assert_eq(_healthbar.healthbar.modulate, _healthbar.half_color)
	
	_healthbar.free()
	
func test_update_healthbar_under_35():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	_healthbar.update_health(25)
	
	assert_almost_eq(_healthbar.healthbar.scale.x, 0.25, 0.01)
	assert_eq(_healthbar.healthbar.modulate, _healthbar.low_color)
	
	_healthbar.free()
	
func test_update_healthbar_under_0():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	assert_null(_healthbar.update_health(-27))

	_healthbar.free()

func test_update_healthbar_over_max():
	var _healthbar = HealthDisplay.instance()
	self.add_child(_healthbar)
	
	assert_not_null(_healthbar)
	
	_healthbar.max_value = 100
	
	assert_null(_healthbar.update_health(400))

	_healthbar.free()
