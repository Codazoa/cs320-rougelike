extends Camera2D


"""
	Camera that acts as the base for the Editor GUI
	
	@desc:
		This scene is always present in the scene tree/can be switched to at
		any time by key press. Upon opening, it pauses the rest of the game
		and instances the EditorGUI around the player. It acts as the "main"
		node for the editor processes/connections to the rest of the game.
"""


var viewport_size
var player
var player_position
var editor_open
var editor_scene = preload("res://scenes/player_editor/EditorGUI.tscn")
var cursor_scene = preload("res://scenes/player_editor/EditorCursor.tscn")

signal cancel_editor


# Called when the node enters the scene tree for the first time.
func _ready():
	# Allows for processing despite the game being paused
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_process_input(true)
	
	# Set static position at game runtime
	viewport_size = get_viewport_rect().size
	offset.x = viewport_size.x / 2
	offset.y = viewport_size.y * 2
	set_zoom(Vector2(0.35,0.35))
	
	player = get_node("/root/World/PlayerCharacter")
	
	editor_open = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


"""
	Take in key press input and instance the editor or remove it
"""
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_I:
			#TO-DO: This case won't run because the scene tree is paused
			if editor_open == true:
				_on_quit_editor()
				
			if editor_open == false:
				editor_open = true
				current = true
				player.go_static()
				Physics2DServer.set_active(true)
				player_position = player.playerPos.global_position
				player.playerPos.position = get_camera_screen_center()
				player.go_static()
				get_tree().paused = true
				player.playerPos.get_child(2).visible = false
				
				var editor_instance = editor_scene.instance()
				editor_instance.connect("quit_editor", self, "_on_quit_editor")
				self.connect("cancel_editor", editor_instance, "_on_edits_canceled")
				add_child(editor_instance)
				
				var cursor_instance = cursor_scene.instance()
				add_child(cursor_instance)



"""
	Upon quitting the editor, clean up (remove GUI, position player back, unpause)
"""
func _on_quit_editor():
	editor_open = false
	emit_signal("cancel_editor") # have editor erase its dictionary/tween off screen
	remove_child($EditorGUI)
	remove_child($EditorCursor)
	get_tree().paused = false
	player.playerPos.position = player_position
	player.playerPos.get_child(2).visible = true
	player.exit_static()
	current = false
