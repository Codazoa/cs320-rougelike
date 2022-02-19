extends Area2D

# TO-DO:
# In the future this scene will be used to instantiate a feature dropped by an enemy
# by receiving signals of dropped enemies and grabbing the corresponding feature from the database


func _ready():
	# Set texture of sprite to texture of feature
	get_node("Sprite").set_texture(FeatureDatabase.get_feature("Eyeball 1").texture)

func _on_FeatureObject_body_entered(body):
	if body == GameManager.player:
		GameManager.player.inventory.add_feature("Eyeball 1", 1)
		queue_free()
