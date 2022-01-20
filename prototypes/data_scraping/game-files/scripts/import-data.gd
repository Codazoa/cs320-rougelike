extends Node

#This needs to be in autoload under project settings
#Other scripts and objects in the game will need this script

var color_data

func _ready():
	color_data = loadJson("res://data/color-info.json")
	print(color_data)
	
func loadJson(path):
	var file = File.new() #create new file 
	file.open(path, File.READ) #open the json file into the new file
	var json = JSON.parse(file.get_as_text()) #parse the JSON
	file.close() #close the file
	return json.result #return the json result
