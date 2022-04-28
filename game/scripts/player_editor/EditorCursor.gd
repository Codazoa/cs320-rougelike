extends Area2D


"""
	Implements main functionality of editor: pickup/placement of parts for player
	
	@desc:
		The cursor is an Area2D collision object that follows the exact
		position of the computer cursor. When it detects collisions it identifies
		if the part is interactable, and if the player clicks/unclicks it 
		determines what should be done. Whether that is grabbing a part from
		the GUI or player's body, or placing a part onto the player's body.
		The instancing of these parts onto the player is done here as well.
"""


var player
var body_part
var attach_section1
var attach_section2
var over_player
var over_attach_point
var holding_part

var draggable_part = preload("res://scenes/player_editor/DraggablePart.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	holding_part = false
	over_player = false
	over_attach_point = false
	body_part = null
	player = get_node("/root/World/PlayerCharacter")
	attach_section1 = get_node("/root/World/PlayerCharacter/body")
	attach_section2 = get_node("/root/World/PlayerCharacter/PlayerPos/Head")
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	
	if holding_part == false:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			_on_part_pickup()


"""
	Checks to see where part dropped. If functional, it must be over an 
	attachment slot, and if cosmetic it must be over the body but not an
	attachment slot. If part is in incorrect position, it is freed from the scene,
	otherwise the instancing onto the player is done here. 
"""
func _on_part_dropped(part):
	holding_part = false
	
	# Get scene of part dropped, instance onto player
	var part_resource = PartDatabase.get_part(part)
	if part_resource[0].type == PartResource.PartType.FUNCTIONAL:
		if over_attach_point:
			# Erase any part already on attach point
			body_part.remove_child(1)
			var added_part = part_resource[1].instance()
			added_part.position = body_part.position
			added_part.slot_num = body_part.slot_num
			body_part.add_child(added_part)
			
	elif part_resource[0].type == PartResource.PartType.COSMETIC:
		if (over_player == true) and (over_attach_point == false):
			var added_part = part_resource[1].instance()
			added_part.position = body_part.position
			added_part.slot_num = body_part.slot_num
			body_part.add_child(added_part)


"""
	Checks to see if cursor is over valid part, much like _on_part_dropped(),
	then instances draggable part for adding somewhere else, and removes
	the part child from the player at that original location.
"""
func _on_part_pickup():
	# Check to see if part was picked up from GUI
	if get_node("/root/World").DraggablePart != null:
		holding_part = true
		
	if over_attach_point:
		if body_part.get_child(1) != null:
			var grabbed_part = draggable_part.instance() 
			grabbed_part.part_name = body_part.get_child(1).name
			grabbed_part.position = get_global_mouse_position()
			get_node("/root/World").add_child(grabbed_part)
			# Erase the part currently on it
			body_part.remove_child(1)
			holding_part = true
			
	elif over_player:
		# If we are over a legit cosmetic part
		if PartDatabase.get_part(body_part.name) != null:
			var grabbed_part = draggable_part.instance()
			grabbed_part.part_name = body_part.name
			grabbed_part.position = get_global_mouse_position()
			get_node("/root/World").add_child(grabbed_part)
			# Erase the part currently on it
			body_part.queue_free()
			holding_part = true


"""
	Upon collisions with cursor, set flags for checking later if interaction
"""
func _on_EditorCursor_body_entered(body):
	# Save the specific body part for reference
	body_part = body
	if (body == player.PlayerPos) or (body == player.body) \
	or (body == player.tail1) or (body == player.tail2):
		over_player = true
	if (body == attach_section2.rightArmSlot.Area2D) \
	 or (body == attach_section2.leftArmSlot.Area2D):
		over_attach_point = true
	if (body == attach_section1.bSlot0.Area2D) or (body == attach_section1.bSlot1.Area2D) \
	or (body == attach_section1.bSlot2.Area2D) or (body == attach_section1.bSlot3.Area2D):
		over_attach_point = true

"""
	Upon exiting collisions with cursor, reset flags if necessary
"""
func _on_EditorCursor_body_exited(body):
	# We are no longer over body, so clear reference
	body_part = null
	if (body == player.PlayerPos) or (body == player.body) \
	or (body == player.tail1) or (body == player.tail2):
		over_player = false
	if (body == attach_section2.rightArmSlot.Area2D) \
	 or (body == attach_section2.leftArmSlot.Area2D):
		over_attach_point = false
	if (body == attach_section1.bSlot0.Area2D) or (body == attach_section1.bSlot1.Area2D) \
	or (body == attach_section1.bSlot2.Area2D) or (body == attach_section1.bSlot3.Area2D):
		over_attach_point = false
