extends Node2D


"""
	Base script for managing the GUI of the editor and its functions
	
	@desc: 
		This script connects some of the functions of various children of the
		GUI to their actual purpose, mostly in regards to canceling/accepting
		the edits to the player, setting the size of the GUI itself, and
		changing the name of the player.
"""


# !! Have EditorGUI work off of Camera2D
# !! Change viewport info to camera2d
# !! Have editor be instanced as child of camera2d

var viewport_size
var name_edit
var name_save
var new_name
var player

signal quit_editor


func _ready():
	player = get_node("/root/World/PlayerCharacter")
	name_edit = get_node("/root/World/EditorCamera/EditorGUI/ScreenDivide1/NameEdit")
	name_edit.text = name_save
	
	# Get the dimensions of the current Camera2D
	var camera_transform = get_parent().get_canvas_transform()
	var min_position = -camera_transform.get_origin() / camera_transform.get_scale()
	viewport_size = get_viewport_rect().size
	var camera_size = viewport_size / camera_transform.get_scale()
	
	# Cursed math below (to set adaptable margins for screen ratio)
	$ScreenDivide1.margin_left = camera_size.x / 40
	$ScreenDivide1.margin_right = camera_size.x / 3
	$ScreenDivide1.margin_top = camera_size.y / 30
	$ScreenDivide1.margin_bottom = camera_size.y - (camera_size.y / 30)
	
	$ScreenDivide2.margin_left = camera_size.x * 0.35
	$ScreenDivide2.margin_right = camera_size.x * 0.65
	$ScreenDivide2.margin_top = camera_size.y * 0.9
	$ScreenDivide2.margin_bottom = camera_size.y - (camera_size.y / 20)
	
	$ScreenDivide3.margin_left = (camera_size.x / 3) * 2
	$ScreenDivide3.margin_right = camera_size.x - (camera_size.x / 30)
	$ScreenDivide3.margin_top = camera_size.y / 30
	$ScreenDivide3.margin_bottom = camera_size.y - (camera_size.y / 30)
	
	position.x = min_position.x + camera_size.x / 80
	position.y = min_position.y - camera_size.y / 30


func _on_edits_canceled():
	# TO-DO: This is not ideal as upon cancel, it clears the entire player of
	#		all parts. To fix, add "new" flag to parts, and check for that when
	#		removing parts. Then unmark all new flags when accepting.

	for cosmetic_part in player.Cosmetics:
		player.Cosmetics.remove_child(cosmetic_part)
	
	for slot in player.body:
		if slot.Type == Position2D:
			slot.remove_child(1)
	
	new_name = ""
	emit_signal("quit_editor")
	
	
func _on_edits_accepted():
	#TO-DO:
	#	iterate through player part slots/cosmetic section
	#	Save to creaturesave
	#	also save name written in lineedit to creaturesave
	name_save = new_name
	emit_signal("quit_editor")


func _on_name_changed():
	new_name = name_edit.text
