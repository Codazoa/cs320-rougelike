extends Node


"""
	Holds parts picked up by player for utilization in editor.
	
	@desc:
		This script uses a set of arrays for categorizing parts collected by
		player. It is a singleton to allow for easy access by different scenes.
"""


signal inventory_changed

# Arrays holding parts player has collected.
# Multiple arrays to prevent the Editor from having to parse thru one array
# to find specific types to fill each GUI section every time inventory updates.
var cosmetic_inventory = []
var functional_inventory = []
var color_inventory = []
var pattern_inventory = []
var body_inventory = []
var limb_inventory = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
"""
	Matches parts picked up to correct type and stores in specific array
"""
func _on_part_pickup(player_part):
	var specific_inventory
	
	match player_part[0].type:
		PartResource.PartType.COSMETIC:
			specific_inventory = cosmetic_inventory
		PartResource.PartType.FUNCTIONAL:
			specific_inventory = functional_inventory
		PartResource.PartType.COLOR:
			specific_inventory = color_inventory
		PartResource.PartType.PATTERN:
			specific_inventory = pattern_inventory
		PartResource.PartType.BODY:
			specific_inventory = body_inventory
		PartResource.PartType.LIMB:
			specific_inventory = limb_inventory
			
	# Check if creature_part already present
	if len(specific_inventory) != 0:
		for part in specific_inventory:
			if player_part[0] == part:
				return
	
	specific_inventory.append(player_part)
	emit_signal("inventory_changed")


func get_player_inventory(type):
	match type:
		"Cosmetic":
			return cosmetic_inventory
		"Functional":
			return functional_inventory
		"Color":
			return color_inventory
		"Pattern":
			return pattern_inventory
		"Body":
			return body_inventory
		"Limb":
			return limb_inventory
		_:
			return null
