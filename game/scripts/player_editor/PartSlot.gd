extends TextureRect


"""
	Slot in the PartsDisplay grid, displaying a given part from the inventory,
	and implementing the function of instancing a DraggablePart upon mouse click. 
"""


var draggable_part = preload("res://scenes/player_editor/DraggablePart.tscn")
var part_name
var currently_holding_part

signal part_grabbed


func _ready():
	currently_holding_part = false


func _gui_input(event):
	if currently_holding_part == false:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				var grabbed_part = draggable_part.instance()
				#EditorCursor.part_name = part_name
				grabbed_part.texture = self.texture
				grabbed_part.part_name = part_name
				grabbed_part.position = get_global_mouse_position()
				get_node("/root/World").add_child(grabbed_part)
				var path_to_part = get_node("/root/World/DraggablePart")
				get_node("/root/World").move_child(path_to_part, 0)
				path_to_part.connect("part_dropped", self, "_on_part_dropped")
				var cursor = get_node("/root/World/EditorCamera/EditorCursor")
				self.connect("part_grabbed", cursor, "_on_part_pickup")
				path_to_part.connect("part_dropped", cursor, "_on_part_dropped")
				currently_holding_part = true


func _on_part_dropped(part):
	currently_holding_part = false
