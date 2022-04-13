extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_start_button_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_nft_button_pressed():
	pass # Replace with function body.


func _on_settings_button_pressed():
	get_tree().change_scene("res://Scenes/Settings.tscn")


func _on_about_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
