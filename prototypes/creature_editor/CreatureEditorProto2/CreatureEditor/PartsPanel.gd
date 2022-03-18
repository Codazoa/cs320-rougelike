extends Panel


#Initialize the encompassing tab system
var editor_tabs = TabContainer.new()
# The two tabs that will hold the grid types (looks == cosmetics, function == functional parts)
var looks_container = VBoxContainer.new()
var function_container = VBoxContainer.new()

# Initialize the grids which will display the player part inventory
var cosmetic_grid = GridContainer.new()
var functional_grid = GridContainer.new()
var color_grid = GridContainer.new()
var pattern_grid = GridContainer.new()
var body_grid = GridContainer.new()
var limb_grid = GridContainer.new()


func _ready():
	# Instance parts section grids, only if parts type found
	if Inventory.get_player_inventory("Cosmetic").empty() == false:
		_add_grid_child(cosmetic_grid, "Cosmetic")
	if Inventory.get_player_inventory("Functional").empty() == false:
		_add_grid_child(functional_grid, "Functional")
	if Inventory.get_player_inventory("Color").empty() == false:
		_add_grid_child(color_grid, "Color")
	if Inventory.get_player_inventory("Pattern").empty() == false:
		_add_grid_child(pattern_grid, "Pattern")
	if Inventory.get_player_inventory("Body").empty() == false:
		_add_grid_child(body_grid, "Body")
	if Inventory.get_player_inventory("Limb").empty() == false:
		_add_grid_child(limb_grid, "Limb")


#func _process(delta):
#	pass


func _add_grid_child(grid, type):
	add_child(grid)
	for part in Inventory.get_player_inventory(type):
		# Display the sprite of each part in each grid slot
		var part_sprite = Sprite.new()
		part_sprite.name = part.name
		part_sprite.texture = part.texture
		part_sprite.scale = 0.5
		grid.add_child(part_sprite)
