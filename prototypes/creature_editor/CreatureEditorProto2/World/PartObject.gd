extends Area2D

signal part_pickup(part_name)

var creature_part


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("spawn_creature_part", self, "_on_spawn_creature_part")


#func _process(delta):
#	pass


# Might need to do this in main, before we instance the object
func _on_spawn_creature_part (dropped_part):
	creature_part = dropped_part
	$Sprite.texture = creature_part.texture


func _on_body_entered(body):
	if body == get_tree().get_root().get_node("Player"):
		emit_signal("part_pickup", creature_part)
