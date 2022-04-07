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


func _on_video_button_pressed():
	pass # Replace with function body.


func _on_audio_button_pressed():
	pass # Replace with function body.


func _on_control_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
