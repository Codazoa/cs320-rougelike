extends Area2D

# !! Adjust scale as necessary in ready
# !! Make sure when spawning this that you set player_part before instancing
# !! Add path to player in _on_body_entered

signal part_pickup(part_name)

var player_part
export (String) var part = ""

func _ready():
	self.connect("part_pickup", PartInventory, "_on_part_pickup")
	player_part = PartDatabase.get_part("MeleeAttachment")
	$Sprite.texture = player_part[0].texture
	# Adjust scale here if needed


func _on_body_entered(body):
	if body == get_node("/root/World/PlayerCharacter/PlayerPos"):
		emit_signal("part_pickup", player_part)
		queue_free()
