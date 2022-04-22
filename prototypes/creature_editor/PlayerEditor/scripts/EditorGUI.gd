extends Node2D

# !! Have EditorGUI work off of Camera2D

var viewport_size

func _ready():
	viewport_size = get_viewport_rect().size
	
	# Cursed math below
	$ScreenDivide1.margin_left = viewport_size.x / 40
	$ScreenDivide1.margin_right = viewport_size.x / 3
	$ScreenDivide1.margin_top = viewport_size.y / 30
	$ScreenDivide1.margin_bottom = viewport_size.y - (viewport_size.y / 30)
	
	$ScreenDivide2.margin_left = viewport_size.x * 0.35
	$ScreenDivide2.margin_right = viewport_size.x * 0.65
	$ScreenDivide2.margin_top = viewport_size.y * 0.9
	$ScreenDivide2.margin_bottom = viewport_size.y - (viewport_size.y / 30)
	
	$ScreenDivide3.margin_left = (viewport_size.x / 3) * 2
	$ScreenDivide3.margin_right = viewport_size.x - (viewport_size.x / 40)
	$ScreenDivide3.margin_top = viewport_size.y / 30
	$ScreenDivide3.margin_bottom = viewport_size.y - (viewport_size.y / 30)
