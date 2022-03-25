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

export var part_name = ""
var grabbed


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	self.modulate = "22ccae"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	grabbed = false
	
	if grabbed == false:
		drop_part()


func _gui_input(event):
	# Left click
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			grabbed = true


func drop_part():
	emit_signal("part_dropped")
	# TO-DO: Fix this, for some reason its only freeing when editor is exited
	#		And it appears that the object is still locked/in use at this point, by the editor
	queue_free()
