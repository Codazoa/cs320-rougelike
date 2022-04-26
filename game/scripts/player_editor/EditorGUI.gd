extends Node2D

# !! Have EditorGUI work off of Camera2D
# !! Change viewport info to camera2d
# !! Have editor be instanced as child of camera2d

var viewport_size

signal quit_editor


func _ready():
	var camera_transform = get_parent().get_canvas_transform()
	var min_position = -camera_transform.get_origin() / camera_transform.get_scale()
	viewport_size = get_viewport_rect().size
	var camera_size = viewport_size / camera_transform.get_scale()
	
	# Cursed math below
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
	pass
