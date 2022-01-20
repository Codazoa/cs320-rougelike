extends Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	#	var output = []
#	var exitCode = OS.execute("python3", ["testpy.py"], true, output) #test for running python script

	var label = get_node("colorLabel") #select node colorLabel and set it to the variable
	var color = ImportData.color_data["item6"] #calling in color_data from ImportData script and grabbing item1
	#var color = ImportData.color_data["item3"] #calling in color_data from ImportData script and grabbing item1
	
	print("Color", color)
	
	label.set_text(str(color["red"]) + " , " + str(color["green"]) + " , " + str(color["blue"]))	
	self.self_modulate = Color8(color["red"],color["green"],color["blue"])
	
