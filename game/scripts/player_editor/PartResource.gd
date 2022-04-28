extends Resource
class_name PartResource


"""
	Stores part data for instancing into various scenes and for allowing 
	easy access to a part's potential functionality.
"""


export (String) var name
# For displaying short description while hovering in menu
export (String) var hint
# Description will be null if not functional, if null, it isnt displayed in stats
export (String) var description
export (Texture) var texture

enum PartType {COLOR, PATTERN, COSMETIC, FUNCTIONAL, BODY, LIMB}
export (PartType) var type

