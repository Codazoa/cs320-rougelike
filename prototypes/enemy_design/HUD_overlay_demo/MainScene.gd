extends Node

var myTree
var startScene
var currentScene
var mainHud

# Called when the node enters the scene tree for the first time.
func _ready():
	myTree = get_tree()
	myTree.change_scene("res://MainMenu.tscn")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


