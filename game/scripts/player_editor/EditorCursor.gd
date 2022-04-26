extends Area2D


var player
var attach_section1
var attach_section2
var over_player
var over_attach_point


# Called when the node enters the scene tree for the first time.
func _ready():
	over_player = false
	over_attach_point = false
	player = get_node("/root/World/PlayerCharacter")
	attach_section1 = get_node("/root/World/PlayerCharacter/body")
	attach_section2 = get_node("/root/World/PlayerCharacter/PlayerPos/Head")
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	#if mouse is clicked (so you will need to make sure its not holding something)
	#	Call _on_part_pickup

func _on_part_dropped(part):
	var part_resource = PartDatabase.get_part(part)
	#if part_resource[0].type == PartResource.PartType.FUNCTIONAL:
	#	if over_attach_point:
	#		add part_resource[1] instance as a child, and set slot num
	#if part type is cosmetic
	#	see if over the body in general
	pass

func _on_part_pickup():
	#if over_attach_point:
		# Will need reference to body, so have on body entered save a reference to the body
		#erase the part currently on it if there is one
		#spawn draggable part
		# set grabbed to true
	#else if over_player:
		# Do essentially same thing, but check to see if part is there
		# To do this you'll probably need a collision shape on each cosmetic part
	pass

func _on_EditorCursor_body_entered(body):
	print(body)
	if (body == player.PlayerPos) or (body == player.body) \
	or (body == player.tail1) or (body == player.tail2):
		over_player = true
	if (body == attach_section2.rightArmSlot.Area2D) \
	 or (body == attach_section2.leftArmSlot.Area2D):
		over_attach_point = true
	if (body == attach_section1.bSlot0.Area2D) or (body == attach_section1.bSlot1.Area2D) \
	or (body == attach_section1.bSlot2.Area2D) or (body == attach_section1.bSlot3.Area2D):
		over_attach_point = true

func _on_EditorCursor_body_exited(body):
	print(body)
	if (body == player.PlayerPos) or (body == player.body) \
	or (body == player.tail1) or (body == player.tail2):
		over_player = false
	if (body == attach_section2.rightArmSlot.Area2D) \
	 or (body == attach_section2.leftArmSlot.Area2D):
		over_attach_point = false
	if (body == attach_section1.bSlot0.Area2D) or (body == attach_section1.bSlot1.Area2D) \
	or (body == attach_section1.bSlot2.Area2D) or (body == attach_section1.bSlot3.Area2D):
		over_attach_point = false
