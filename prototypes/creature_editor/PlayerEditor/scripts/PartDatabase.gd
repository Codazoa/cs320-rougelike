extends Node

# !! Fix PartsLibrary path
# !! Make dict now hold tuple with resource in slot 1, and path to part scene
#	 for instancing. 
# !! Make singleton

# Dict to hold all creature parts
var parts = {}

func _ready():
	var dir = Directory.new()
	if dir.open("res://PartsLibrary") != OK:
		push_error("PartsLibrary folder missing!")
	
	# Start the directory stream and going thru files
	dir.list_dir_begin()
	var part_file = dir.get_next()
	while part_file != "":
		# If file, load Resource into parts dict
		if not dir.current_is_dir():
			var part_resource = load("res://PartLibrary/%s" % part_file)
			parts[part_resource.name] = part_resource
		
		part_file = dir.next()

func get_part(name):
	return parts[name]
