extends Panel


var select_rect = preload("res://CreatureEditor/SelectPart.tscn") 


func _ready():
	check_grids()


#func _process(delta):
#	pass


func check_grids():
	# Instance parts section grids, only if parts type found
	if Inventory.get_player_inventory("Cosmetic").empty() == false:
		_add_grid_child("Cosmetic")
	if Inventory.get_player_inventory("Functional").empty() == false:
		_add_grid_child("Functional")
	if Inventory.get_player_inventory("Color").empty() == false:
		_add_grid_child("Color")
	if Inventory.get_player_inventory("Pattern").empty() == false:
		_add_grid_child("Pattern")
	if Inventory.get_player_inventory("Body").empty() == false:
		_add_grid_child("Body")
	if Inventory.get_player_inventory("Limb").empty() == false:
		_add_grid_child("Limb")


func _add_grid_child(type):
	var grid_to_fill
	match type:
		"Cosmetic":
			grid_to_fill = $TabContainer/Cosmetic/ScrollContainer1/CPartGrid
		"Functional":
			grid_to_fill = $TabContainer/Functional/ScrollContainer1/FPartGrid
		"Color":
			grid_to_fill = $TabContainer/Cosmetic/ScrollContainer2/ColorGrid
		"Pattern":
			grid_to_fill = $TabContainer/Cosmetic/ScrollContainer3/PatternGrid
		"Body":
			grid_to_fill = $TabContainer/Functional/ScrollContainer2/BodyGrid
		"Limb":
			grid_to_fill = $TabContainer/Functional/ScrollContainer3/LimbGrid
	
	for part in Inventory.get_player_inventory(type):
		# Display the sprite of each part in each grid slot
		var part_rect = select_rect.instance()
		part_rect.part_name = part.name
		part_rect.texture = part.texture
		grid_to_fill.add_child(part_rect)
		#Connect gui_input signal to _on_item_gui_input()
