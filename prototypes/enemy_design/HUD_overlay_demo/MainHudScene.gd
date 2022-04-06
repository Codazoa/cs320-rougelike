extends Node

onready var root = get_tree().get_root()

const PLAYER = preload("res://Player.tscn")

var gameSizeX = 0
var gameSizeY = 0

var rightMargin = 0
var leftMargin = 0
var topMargin = 0
var bottomMargin = 0

var screenX
var screenY

# Called when the node enters the scene tree for the first time.
func _ready():
	screenX = get_viewport().size.x
	screenY = get_viewport().size.y
	
	var player = PLAYER.instance()
	
	rightMargin = $MainHUD/RightUnderBar.get_rect().size.x
	leftMargin = $MainHUD/LeftBar.get_rect().size.x
	topMargin = $MainHUD/UpperBar.get_rect().size.y
	bottomMargin = $MainHUD/LowerBar.get_rect().size.y
	
	player.updateMargin((topMargin + 16), (bottomMargin + 32), (leftMargin + 16), (rightMargin + 16))
	
	gameSizeX = screenX - rightMargin - leftMargin
	gameSizeY = screenY - topMargin - bottomMargin
	
	add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
