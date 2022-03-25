extends Area2D

signal part_pickup(part_name)

var creature_part


# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("body_entered", self, "_on_body_entered")
	#connect("spawn_creature_part", self, "_on_spawn_creature_part")
	pass


func _process(delta):
	if (($Sprite.texture == null) and (creature_part != null)):
		$Sprite.texture = creature_part.texture
		$Sprite.scale.x = 0.25
		$Sprite.scale.y = 0.25


func _on_body_entered(body):
	if body == get_parent().get_node("Main/Player"):
		emit_signal("part_pickup", creature_part)
		queue_free()
