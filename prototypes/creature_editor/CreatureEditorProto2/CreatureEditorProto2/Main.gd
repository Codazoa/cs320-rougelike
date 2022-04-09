extends Node2D


signal spawn_creature_part(dropped_part)
signal finalize_creature(creature_name, creature_parts)

var editor_scene = preload("res://CreatureEditor/EditorGUI.tscn")
#var draggable_part = preload("res://Player/DraggablePart.tscn")
#var camera_zoom_position
#var camera_default_position = Vector2(511, 301)
var original_player_position


# Initializes game world
func _ready():
	set_as_toplevel(true)
	$Enemy.connect("enemy_death", self, "_on_enemy_death")
	# Get seed for randomization
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#camera_zoom_position = $Player.position
	# TO-DO: Move all camera code to camera script, and have main signal camera with necessary details
	if Input.is_action_pressed("editor_open"):
		original_player_position = $Player.position
		# Pause the game
		get_tree().paused = true
		Physics2DServer.set_active(true)
		$Player.position = get_viewport_rect().size / 2
		$Player.scale = $Player.scale * 2
		# Zoom in and center on the player
		#$Camera2D.set_zoom(Vector2(0.5, 0.5))
		#$Camera2D.position = camera_zoom_position
		
		#Instance the Creature Editor into the scene
		var editor_instance = editor_scene.instance()
		editor_instance.connect("quit_editor", self, "_on_quit_editor")
		add_child(editor_instance)


func _on_enemy_death(dropped_part, vector_position):
	var part_object = load("res://World/PartObject.tscn").instance()
	part_object.position = vector_position
	get_tree().get_root().add_child(part_object)
	part_object.creature_part = dropped_part
	part_object.connect("part_pickup", Inventory, "_on_part_pickup")
	#part_object.Sprite.texture = dropped_part.texture
	#emit_signal("spawn_creature_part", dropped_part)


func _on_quit_editor(creature_name, creature_parts):
	if (creature_name != null) and (creature_parts != null):
		emit_signal("finalize_creature", creature_name, creature_parts)
	# Save scene for quick instancing later
	remove_child($EditorGUI)
	$Player.position = original_player_position
	$Player.scale = Vector2(1,1)
	#$Camera2D.set_zoom(Vector2(1, 1))
	#$Camera2D.position = camera_default_position
	get_tree().paused = false
