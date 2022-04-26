extends TabContainer


var part_slot = preload("res://scenes/player_editor/PartSlot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	update_grids()


func update_grids():
	# Instance part slots in respective grids, only if part type found
	if PartInventory.get_player_inventory("Cosmetic").empty() == false:
		_add_grid_slots("Cosmetic")
	if PartInventory.get_player_inventory("Functional").empty() == false:
		_add_grid_slots("Functional")
	if PartInventory.get_player_inventory("Color").empty() == false:
		_add_grid_slots("Color")
	if PartInventory.get_player_inventory("Pattern").empty() == false:
		_add_grid_slots("Pattern")
	if PartInventory.get_player_inventory("Body").empty() == false:
		_add_grid_slots("Body")
	if PartInventory.get_player_inventory("Limb").empty() == false:
		_add_grid_slots("Limb")
		
func _add_grid_slots(type):
	var grid_to_fill
	match type:
		"Cosmetic":
			grid_to_fill = $Cosmetic/PanelContainer/ScrollContainer/GridContainer
		"Functional":
			grid_to_fill = $Functional/PanelContainer/ScrollContainer/GridContainer
		"Color":
			grid_to_fill = $Cosmetic/PanelContainer2/ScrollContainer/GridContainer
		"Pattern":
			grid_to_fill = $Cosmetic/PanelContainer3/ScrollContainer/GridContainer
		"Body":
			grid_to_fill = $Functional/PanelContainer2/ScrollContainer/GridContainer
		"Limb":
			grid_to_fill = $Functional/PanelContainer3/ScrollContainer/GridContainer
	
	for part in PartInventory.get_player_inventory(type):
		# Display the sprite of each part in each grid slot
		var slot_instance = part_slot.instance()
		slot_instance.part_name = part[0].name
		slot_instance.texture = part[0].texture
		grid_to_fill.add_child(slot_instance)
