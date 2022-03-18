extends Node2D


signal spawn_creature_part(dropped_part)
signal finalize_creature(creature_name, creature_parts)

var editor_scene = preload("res://CreatureEditor/EditorGUI.tscn")
var editor_instance
var camera_zoom_position


# Initializes game world
func _ready():
	set_as_toplevel(true)
	connect("enemy_death", self, "_on_enemy_death")
	connect("quit_editor", self, "_on_quit_editor")
	# Get seed for randomization
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_zoom_position = $Player.position
	# TO-DO: Move all camera code to camera script, and have main signal camera with necessary details
	if Input.is_action_pressed("editor_open"):
		# Pause the game
		get_tree().paused = true
		# Zoom in and center on the player
		$Camera2D.set_zoom(Vector2(0.5, 0.5))
		$Camera2D.align($Player)
		#Instance the Creature Editor into the scene
		if editor_instance == null:
			var editor_instance = editor_scene.instance()
		add_child(editor_instance)


func _on_enemy_death(dropped_part, vector_position):
	var part_object = load("res://World/PartObject.tscn").instance()
	part_object.position = vector_position
	get_tree().get_root().add_child(part_object)
	emit_signal("spawn_creature_part", dropped_part)


func _on_quit_editor(creature_name, creature_parts):
	if (creature_name != null) and (creature_parts != null):
		emit_signal("finalize_creature", creature_name, creature_parts)
	# Save scene for quick instancing later
	editor_instance = $EditorGUI
	remove_child($EditorGUI)
	$Camera2D.set_zoom(Vector2(1, 1))
	$Camera2D.align(get_tree().viewport)
	get_tree().paused = false
