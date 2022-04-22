extends Area2D

# !! Adjust scale as necessary in ready
# !! Make sure when spawning this that you set player_part before instancing
# !! Add path to player in _on_body_entered

signal part_pickup(part_name)

var player_part

func _ready():
	$Sprite.texture = player_part.texture
	# Adjust scale here if needed


func _on_body_entered(body):
	#if body == get_parent().get_node(<PATH TO PLAYER>):
	#	emit_signal("part_pickup", creature_part)
	#	queue_free()
	pass
