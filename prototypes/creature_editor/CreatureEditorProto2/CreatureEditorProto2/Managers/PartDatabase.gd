extends Node

# Dict to hold all creature parts
var parts = {}


func _ready():
	var dir = Directory.new()
	if dir.open("res://CreatureParts") != OK:
		push_error("CreatureParts Folder Missing")
	
	# Start the directory stream and going thru files
	dir.list_dir_begin()
	var part_file = dir.get_next()
	while part_file != "":
		# If file, load Resource into parts dict
		if not dir.current_is_dir():
			var part_resource = load("res://CreatureParts/%s" % part_file)
			parts[part_resource.name] = part_resource
			
		part_file = dir.get_next()


func get_part(name):
	return parts[name]
