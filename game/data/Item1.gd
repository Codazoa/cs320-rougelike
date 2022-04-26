extends RigidBody2D

export (int) var clicks = 0
export (int) var shown = 1
export (int) var score = 1
export (int) var time = 0

var id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	shown = shown + 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Item1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		clicks = clicks + 1
		print(clicks)


func _on_Item2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		clicks = clicks + 1
		print(clicks)


func _on_Item3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		clicks = clicks + 1
		print(clicks)


func _on_Item4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		clicks = clicks + 1
		print(clicks)


func _on_Item5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		clicks = clicks + 1
		print(clicks)
