extends TextureRect


var draggable_part = preload("res://Player/DraggablePart.tscn")
export var part_name = ""
# Wont allow player to spawn more than one part at a time
# When the part is dropped, it will send a signal here to make this false again
var currently_holding_part = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _gui_input(event):
	if currently_holding_part == false:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				var grabbed_part = draggable_part.instance()
				grabbed_part.part_name = part_name
				grabbed_part.get_node("Sprite").texture = self.texture
				grabbed_part.position = get_global_mouse_position()
				get_tree().get_root().get_node("Main").add_child(grabbed_part)
				var path_to_part = get_tree().get_root().get_node("Main").get_node("DraggablePart")
				path_to_part.connect("part_dropped", self, "_on_part_dropped")
				var player = get_tree().get_root().get_node("Main").get_node("Player")
				path_to_part.connect("add_part_player", player, "on_part_received")
				currently_holding_part = true

func _on_part_dropped():
	currently_holding_part = false
