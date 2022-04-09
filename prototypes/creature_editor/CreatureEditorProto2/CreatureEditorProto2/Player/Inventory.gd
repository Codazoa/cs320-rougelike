extends Node

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
	#connect("part_pickup", self, "_on_part_pickup")
	pass


func _on_part_pickup(creature_part):
	var specific_inventory
		
	match creature_part.type:
		CreaturePart.PartType.COSMETIC:
			specific_inventory = cosmetic_inventory
		CreaturePart.PartType.FUNCTIONAL:
			specific_inventory = functional_inventory
		CreaturePart.PartType.COLOR:
			specific_inventory = color_inventory
		CreaturePart.PartType.PATTERN:
			specific_inventory = pattern_inventory
		CreaturePart.PartType.BODY:
			specific_inventory = body_inventory
		CreaturePart.PartType.LIMB:
			specific_inventory = limb_inventory
	
	# Check if creature_part already present
	if len(specific_inventory) != 0:
		for part in specific_inventory:
			if creature_part == part:
				return
	
	specific_inventory.append(creature_part)
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

