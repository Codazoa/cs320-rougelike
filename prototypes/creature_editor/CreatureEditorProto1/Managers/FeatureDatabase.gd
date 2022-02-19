extends Node


# TO-DO: This needs to be optimized, don't have it load on startup in the future
#		 Make it store load the database as the resources appear in the game?		


var features = {}


func _ready():
	var directory = Directory.new()
	directory.open("res://Features")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while (filename):
		if not directory.current_is_dir():
			var feature = load("res://Features/%s" % filename)
			features[feature.name] = feature
			
		filename = directory.get_next()

func get_feature(feature_name):
	return features[feature_name]
