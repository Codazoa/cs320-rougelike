extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Point to the actual game here
func _on_start_button_pressed():
	pass # Replace with function body.

# Change the scene back to the main menu
func _on_back_button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")

# Exit the application
func _on_quit_button_pressed():
	get_tree().quit()
