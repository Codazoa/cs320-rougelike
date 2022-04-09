extends 'res://addons/gut/test.gd'

var Inventory = load("res://Player/Inventory.gd")

# Acceptance Tests (Black-Box Testing)
class TestPartPickup:
	extends 'res://addons/gut/test.gd'
	
	# Base Cases
	
	# Test when nonexistent creature part is passed in
	func test_no_creature_part():
		var non_existent_part = load("res://Test/BasicEar.tres")
		var result = Inventory._on_part_pickup(non_existent_part)
		assert_eq(-1, result, "Should return -1 if nonexistent part given")
		
	# Test when what is passed in is not a creature part
	func test_not_part_type():
		var result = Inventory._on_part_pickup(57)
		assert_eq(-1, result, "Should return -1 when not a part")
	
	# Test when creature type passed in doesnt have a correct type
	func test_part_type_not_exist():
		var part_bad_type = load("res://Test/BasicNose.tres")
		var result = Inventory._on_part_pickup(part_bad_type)
		assert_eq(-1, result, "Should return -1 when part not a correct type")
	
	# Tests to check functionality with a working creature part
	var working_creature_part = load("res://CreatureParts/BasicEyeball.tres")
	var broken_creature_part #load a broken part
	
	# Test when creature part is not present in the inventory already
	func test_part_not_already_present():
		Inventory.cosmetic_inventory = []
		var result = Inventory._on_part_pickup(working_creature_part)
		assert_eq(1, result, "Should return 1 when part was added to inventory")
		
	# Test when creature part is already present in the inventory
	func test_part_already_present():
		Inventory.cosmetic_inventory = []
		Inventory._on_part_pickup(working_creature_part)
		var result = Inventory._on_part_pickup(working_creature_part)
		assert_eq(0, result, "Should return 0 when part was already present in inventory")
