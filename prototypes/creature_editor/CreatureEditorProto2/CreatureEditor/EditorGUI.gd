extends Control


# This is the root for the Creature Editor GUI


signal quit_editor(creature_name, creature_parts)

# Dict containing the parts added to the creature and their corresponding slot or coord
var added_parts = {}


func _ready():
	# Prevent the editor from being affected by the game pausing
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	# Connect to the save and the cancel signals from the FinalizeContainer
	connect("creature_saved", self, "_on_creature_saved")
	connect("creature_canceled", self, "_on_creature_canceled")
	


#func _process(delta):
#	pass


func _on_creature_saved(creature_name):
	emit_signal("quit_editor", creature_name, added_parts)

	
func _on_creature_canceled():
	# TO-DO: Remove any new edits made to the creature
	emit_signal("quit_editor", null, null)
