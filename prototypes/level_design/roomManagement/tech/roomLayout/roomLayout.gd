extends Node

var worldManagerNode;
var roomDatabaseNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	#print("Node created: roomLayout");
	#spawnRoom(2, 0);
	
func spawnRoom(roomScene):
	#get map node
	#instance scene
	#var chosenRoom = roomDatabaseNode.grabRoom(roomID, roomIndex);
	var instanced = roomScene.instance();
	self.get_node("map").add_child(instanced);
	#do any needed set up
	
func deleteRoom():
	var terminated = self.get_node("map").get_child(0);
	#print(terminated);
	if(terminated != null):
		terminated.queue_free();
	
func shiftRoom(roomIndex):
	deleteRoom();
	spawnRoom(roomIndex);
