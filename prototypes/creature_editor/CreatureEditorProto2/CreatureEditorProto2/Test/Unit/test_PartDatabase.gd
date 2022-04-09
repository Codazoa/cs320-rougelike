extends 'res://addons/gut/test.gd'

# Function being tested is below:
#func get_part(name):
#	return parts[name]

var PartDatabase = load("res://Managers/PartDatabase.gd")

# Function Coverage Test (White-Box Testing)
class TestPartRetreival:
	extends 'res://addons/gut/test.gd'
	
	var CreaturePart = load("res://CreatureParts/BasicEyeball.tres")
	
	# Test the one function that retreives parts from the database
	func test_retreive_creature_part():
		var result = PartDatabase.get_part("basic_eyeball")
		assert_eq(CreaturePart, result, "Should return the request creature part resource")
