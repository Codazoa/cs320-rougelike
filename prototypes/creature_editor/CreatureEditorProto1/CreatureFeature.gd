extends Resource
class_name FeatureResource

export var name : String
export var stackable : bool = false

# Types of Creature Features
enum FeatureType {COLOR, PATTERN, COSMETIC, SEGMENT, MOVEMENT, ABILITY}
export(FeatureType) var type

export var texture: Texture
