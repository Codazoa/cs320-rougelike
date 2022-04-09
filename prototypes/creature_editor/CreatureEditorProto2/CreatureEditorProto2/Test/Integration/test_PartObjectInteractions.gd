extends 'res://addons/gut/test.gd'

# Top down tests (Integration Testing)
class TestPartObjectCollision:
	extends 'res://addons/gut/test.gd'
	
	# Make a fake lower level system to test on
	var Main = load("res://Main.tscn")
	var PartObject = load("res://World/PartObject.tscn")
	var Player = load("res://Player/Player.tscn")
	var Enemy = load("res://Enemy/Enemy.tscn")
	
	var _part_object = PartObject.instance()
	var _player = Player.instance()
	var _enemy = Enemy.instance()
	
	# Test when part object interacts with player
	func test_collision_with_player():
		_part_object._on_body_entered(_player)
		assert_eq(null, _part_object, "Should be null as part object is freed when collision with player")
		
	# Test when part object interacts with enemy
	func test_collision_not_player():
		_part_object._on_body_entered(_enemy)
		assert(_part_object != null, "The part object should not free itself when colliding with other things")
	
