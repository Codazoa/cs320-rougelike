extends Sprite


"""
	Part object spawned from selecting a part in the editor GUI or from
	grabbing a part off the player.
	
	@desc:
		This scene is a sprite object for mostly visual feedback to the player
		that they are currently holding a part. It also implements minor 
		functionality by notifying the editor cursor when said part has been
		dropped.
"""


var grabbed
var part_name
signal part_dropped(part)

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		grabbed = true
		# Drag slightly behind mouse, for more fluid animation
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		grabbed = false
		
	if grabbed == false:
		emit_signal("part_dropped", part_name)
		queue_free()
