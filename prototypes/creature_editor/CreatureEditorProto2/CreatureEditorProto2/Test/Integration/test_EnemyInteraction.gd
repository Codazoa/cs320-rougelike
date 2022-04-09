extends 'res://addons/gut/test.gd'

# Top down tests (Integration Testing)
class TestEnemyCollision:
	extends 'res://addons/gut/test.gd'
	
	# Make a fake lower level system to test on
	var Main = load("res://Main.tscn")
	var PartObject = load("res://World/PartObject.tscn")
	var Player = load("res://Player/Player.tscn")
	var Enemy = load("res://Enemy/Enemy.tscn")
	var Wall = load("res://World/MapBorder.tscn")
	
	var _part_object = PartObject.instance()
	var _player = Player.instance()
	var _enemy = Enemy.instance()
	var _wall = Wall.instance()
	
	# Test when colliding with player, but no death
	func test_basic_collision_with_player():
		_enemy.hitpoints = 10
		_enemy._on_body_entered(_player)
		assert_eq(5, _enemy.hitpoints, "Collision w/ player should decrease hp by 5")
		
	# Test when colliding with player, leading to death
	func test_death_collision_with_player():
		_enemy.hitpoints = 5
		_enemy._on_body_entered(_player)
		assert_signal_emitted("enemy_death", "Hp of zero after collision w/ player should kill enemy")
	
	# Test when colliding with other entities (i.e. part object)
	func test_collision_with_entities():
		var old_velocity = _enemy.velocity
		_enemy._on_body_entered(_part_object)
		assert_ne(old_velocity, _enemy.velocity, "The enemy should change direction when colliding w/ entities")
		
	# Test when colling with environment objects (i.e. wall)
	func test_collision_with_environment():
		_enemy.hitpoints = 10
		var old_velocity = _enemy.velocity
		_enemy._on_body_entered(_wall)
		assert_ne(old_velocity, _enemy.velocity, "The enemy should change direction when colliding w/ environment")
