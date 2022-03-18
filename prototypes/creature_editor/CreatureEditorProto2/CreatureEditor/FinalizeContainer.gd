extends HBoxContainer


signal creature_saved(creature_name)
signal creature_cancelled

var creature_name


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# When the player presses the accept button, sound out a signal to be received from the editor
func _on_accept_pressed():
	emit_signal("creature_saved", creature_name)
