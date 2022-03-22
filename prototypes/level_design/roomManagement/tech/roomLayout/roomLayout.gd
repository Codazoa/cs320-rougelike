extends Node

var worldManagerNode;
var roomDatabaseNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Node created: roomLayout");
	spawnRoom(2, 0);
	
func spawnRoom(roomID, roomIndex):
	#get map node
	#instance scene
	var chosenRoom = roomDatabaseNode.grabRoom(roomID, roomIndex);
	self.get_node("map").add_child(chosenRoom.instance());
	#do any needed set up
	
func deleteRoom():
	pass;
	
func shiftRoom(roomID, roomIndex):
	deleteRoom();
	spawnRoom(roomID, roomIndex);
