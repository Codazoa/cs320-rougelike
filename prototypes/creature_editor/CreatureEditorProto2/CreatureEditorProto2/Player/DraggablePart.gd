extends Area2D


# The DraggablePart scene needs to be able to be made child of a player and also 
# not child of the player by responding to mouse clicks when the editor gui is open
# So most of the drag and drop functions should go here, while the player body should
# have some receiving drop functions
# And SelectPart (TextureRect) should merely spawn an instance of this draggable part
# If selected on body of player and in editor, just delete

#Eventually we also want to store stats in here from looking up the part in the database
# These stats would then be applied to the player upon adding to child

signal part_dropped
signal add_part_player(part, position)

var over_player = false
var player
var body_coordinates
export var part_name = ""
var grabbed


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Main").get_node("Player")
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_process_input(true)
	self.scale = self.scale / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		grabbed = true
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		grabbed = false
	
	if grabbed == false:
		drop_part()


func drop_part():
	if over_player:
		body_coordinates = self.position
		emit_signal("add_part_player", part_name, body_coordinates)
	#	in player's receive function, lerp the size up and back down so it kind of bounces when the part is added (visual feedback)
	emit_signal("part_dropped")
	queue_free()


func _on_DraggablePart_body_entered(body):
	if body == player:
		print("over player")
		over_player = true
		# Body coordinates needs to be equal to the position on the player relative to how the player 
		# scene positions the player, which is centers it on the origin.
		# So a possible solution here, is that when the editor gui opens up, you also set a point
		# at the center of the viewport, which will also be the center of the player.
		# Take the x y distance from the point and if the part is on the first half of the screen
		# in either the x or y direction, make sure to make that corresponding x or y negative
		# For example: if part is at position 300 pixels for x, but the screen halfway point is 500,
		# then the x will be negative. 
		
		# Then in player set process during pause, but make it so that input functionality only works
		# when the scene tree isnt paused, just do an if statement.
	else:
		print("not over player")
		over_player = false
