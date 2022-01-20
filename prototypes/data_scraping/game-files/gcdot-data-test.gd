extends Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	var label = get_node("colorLabel")
	var output = []
	var exitCode = OS.execute("python3", ["testpy.py"], true, output)
	label.set_text(output[0])
