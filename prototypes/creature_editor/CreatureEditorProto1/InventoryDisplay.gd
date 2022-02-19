extends GridContainer

# TO-DO: Make this a separate scene

func _ready():
	GameManager.connect("player_initialised", self, "_on_player_initialised")
	
func _on_player_initialised(player):
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
func _on_player_inventory_changed(inventory):
	for old_text in get_children():
		old_text.queue_free()
		
	for feature in inventory.get_features():
		var feature_label = Label.new()
		feature_label.text = "%s : %d" % [feature.feature_reference.name, feature.quantity]
		add_child(feature_label)
