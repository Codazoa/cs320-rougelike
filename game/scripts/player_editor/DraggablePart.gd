extends Sprite


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
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		grabbed = false
		
	if grabbed == false:
		emit_signal("part_dropped", part_name)
		queue_free()
