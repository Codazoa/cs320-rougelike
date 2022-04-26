extends "res://addons/gut/test.gd"

var Slime = load("res://scenes/enemies/the_Slime.tscn")
var Enemy = load("res://scenes/enemies/EnemyEntity.tscn")

################################################################################

# Black Box Testing - Acceptance Test
func test_Slime_updateMovement():
	
	var _slime = Slime.instance()
	var result = false
	
	_slime.setEnemyPosition(Vector2(0,1))
	_slime.tracking = true
	
	_slime.updateMovement()
	
	result = _slime.getEnemyPosition()
	
	assert_eq(result, Vector2(0,1), "Vector should have been (0,1)")
	
################################################################################
	
# Intergration Testing - Big Bang Testing - Testing Slime Speed change upon 2nd built-in script
func test_Slime_speedChange():
	var _slime = Slime.instance()
	var _genericEnemy = Enemy.instance()
	
	var slimeSpeed = _slime.getEnemySpeed()
	var speed = _genericEnemy.getEnemySpeed()
	
	var isDifferent = false
	
	if(slimeSpeed != speed):
		isDifferent = true
	
	assert_eq(isDifferent, false, "Their speeds should be different if slime script works properly")
	
################################################################################
	
# Black Box Testing - Acceptance Test
func test_updatePosition():
	var _slime = Slime.instance()
	
	var testVector = Vector2(167, 435)
	
	_slime.setEnemyPosition(testVector)
	var returnVector = _slime.getEnemyPosition()
	
################################################################################
	
# White Box Test - 33% statement coverage, 100% with the following 2 tests
func test_onEnemyHit_invalidInput():
	
	var _slime = Slime.instance()
	var result = false
	
	result = _slime.onEnemyHit(-10)
	
	assert_eq(result, -1, "When given -10, expected return -1 for invalid damage input")
	
	result = _slime.onEnemyHit(0)
	
	
# White Box Test - 33% statement coverage, 100% with the previous test and next tests
func test_onEnemyHit_hasWeakness():
	var _slime = Slime.instance()
	
	_slime.hasWeakness = true
	
	var myDamage = ((_slime.defense*0.5) - (6*_slime.modi))
	var theirDamage = _slime.onEnemyHit(6)
		
	assert_eq(theirDamage, myDamage, "Damage should equal exactly one unless weakness proc")
	
	
# White Box Test - 33% statement coverage, 100% with previous 2 test 
func test_onEnemyHit():
	var _slime = Slime.instance()
	
	var myDamage = ((_slime.defense)-(6*_slime.modi))
	var theirDamage = _slime.onEnemyHit(6)
	
	assert_eq(theirDamage, myDamage, "Damage should equal exactly one")
	
################################################################################

# Black Box Testing - Acceptance Testing
func test_onEnemyHit_exactExpectedDamage():
	var _slime = Slime.instance()

	var beginHealth = _slime.getEnemyHealth()

	_slime.onEnemyHit(6)
	
	var health = _slime.getEnemyHealth()
	var damageDealt = beginHealth - health
	
	assert_eq(damageDealt, ((_slime.getEnemyDefense() - 6)*2), "Exact damage should be compared to damage dealt") 
	
	_slime.onEnemyHit(6)
	
	health = _slime.getEnemyHealth()
	damageDealt = beginHealth - health
	
	assert_eq(damageDealt, ((_slime.getEnemyDefense() - 6)*2), "Exact damage should be compared to damage dealt")
	
################################################################################
# Black Box Testing - Acceptance Test
func test_onEnemyHit_diesOnOneHit():
	var _slime = Slime.instance()
	
	_slime.onEnemyHit(100000)
	
	var result = _slime.isVisible
	assert_true(!(result))
	
################################################################################
	
# White Box Test - 25% branch coverage, 100% with the next 3 tests
func test_isAligned_alignedXAndY():
	var _slime = Slime.instance()
	
	_slime.position = Vector2(0,0)
	
	var nextVector = Vector2(0, 0)
	
	var result = _slime.isAligned(nextVector)
	
	assert_eq(result, true, "Should be alligned with X and Y")
	
	
# White Box Test - 25% branch coverage, 100% with the previous test and following 2 tests
func test_isAligned_alignedX():
	var _slime = Slime.instance()
	
	_slime.position = Vector2(0,0)
	
	var nextVector = Vector2(0, 100)
	
	var result = _slime.isAligned(nextVector)
	
	assert_eq(result, true, "Should be alligned with X specifically")
	
	
# White Box Test - 25% branch coverage, 100% with following test and 2 prior tests
func test_isAligned_alignedY():
	var _slime = Slime.instance()
	
	_slime.position = Vector2(0,0)
	
	var nextVector = Vector2(100, 0)
	
	var result = _slime.isAligned(nextVector)
	
	assert_eq(result, true, "Should be alligned with Y specifically")
	
	
# White Box Test - 25% branch coverage, 100% with the following 3 tests
func test_isAligned_notAligned():
	var _slime = Slime.instance()
	
	_slime.position = Vector2(0,0)
	
	var nextVector = Vector2(100, 100)
	
	var result = _slime.isAligned(nextVector)
	
	assert_eq(result, false, "Shouldn't be aligned with X or Y")
	
################################################################################
