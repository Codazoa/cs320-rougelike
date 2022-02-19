extends Node


signal player_initialised

var player


func _process(delta):
	if not player:
		initialise_player()
		return

func initialise_player():
	player = get_tree().get_root().get_node("Main/Player")
	if not player:
		return
		
	emit_signal("player_initialised", player)
	
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
	
	if ResourceLoader.exists("user://inventory.tres"):
		var existing_inventory = load("user://inventory.tres")
		player.inventory.set_features(existing_inventory.get_features())
	else:
		player.inventory.add_feature("Eyeball 1", 1)
		ResourceSaver.save("user://inventory.tres", player.inventory)

func _on_player_inventory_changed(inventory):
	# TO-DO: This method is an ugly ass Singleton, is there a better approach?
	# 		I dont think so, its a vice of Godot I believe, but ill look into it.
	ResourceSaver.save("user://inventory.tres", inventory)
