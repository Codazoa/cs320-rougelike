extends Node


"""
	Holds quick reference to all possible parts that can be used for the player
	
	@desc:
		This script utilizes a basic dictionary for constant time lookup of parts
		when instancing into scenes (by holding both the part resource and a
		path to its scene in the value of the dict). It updates this part 
		collection upon runtime of game by iterating through the folders 
		containing the resources and scenes. Is a singleton.
"""


# Dict to hold all creature parts
var parts = {}

func _ready():
	var resource_dir = Directory.new()
	if resource_dir.open("res://scripts/player_editor/part_resources") != OK:
		push_error("part_resources folder missing!")
	
	var attachment_dir = Directory.new()
	if attachment_dir.open("res://scenes/player/attachments") != OK:
		push_error("attachments folder missing!")
	
	# Start the directory stream and going thru files
	resource_dir.list_dir_begin()
	attachment_dir.list_dir_begin()
	var resource_file = resource_dir.get_next()
	var attachment_file = attachment_dir.get_next()
	while resource_file != "":
		# If file, load Resource into parts dict
		if not resource_dir.current_is_dir():
			var resource_part = load("res://scripts/player_editor/part_resources/%s" % resource_file)
			if attachment_file != "":
				var attachment_part = load("res://scenes/player/attachments/%s" % attachment_file)
				parts[resource_part.name] = [resource_part, attachment_part]
		
		resource_file = resource_dir.get_next()
		attachment_file = attachment_dir.get_next()

func get_part(name):
	return parts[name]
