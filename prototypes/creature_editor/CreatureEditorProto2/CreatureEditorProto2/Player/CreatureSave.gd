extends Resource
class_name CreatureSave

# Used to reconstruct creatures created

export (String) var name
# The color and pattern strings map to the ID of the CreaturePart resource
export (String) var color
export (String) var pattern

var body_segments = []

var part_slots = {
			"slot1" : null,
			"slot2" : null,
			"slot3" : null,
			"slot4" : null
		}
