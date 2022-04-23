extends Resource
class_name CreaturePart

export (String) var name
export (Texture) var texture

enum PartType {COLOR, PATTERN, COSMETIC, FUNCTIONAL, BODY, LIMB}
export (PartType) var type

# func type_handler
	# adds corresponding features based on type