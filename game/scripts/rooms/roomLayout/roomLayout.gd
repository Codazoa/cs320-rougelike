#All of the following code was written by Sydney Burgess
extends Node

var worldManagerNode;
var roomShiftTimer = -1;
var roomShiftTime = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	#print("Node created: roomLayout");
	#spawnRoom(2, 0);

"""
This function is used to track the roomShiftTimer. The purpose of the timer is to prevent
the player from colliding with a roomshifter multiple times before the room can be properly
shifted.
"""
func _process(delta):
	if(roomShiftTimer != -1):
		roomShiftTimer -= 1;
		#if(roomShiftTimer < -1): roomShiftTimer = -1;

"""
spawnRoom() takes a given scene (intended to be a room scene) and spawns it under the map childnode.
"""
func spawnRoom(roomScene):
	var instanced = roomScene.instance();
	self.get_node("map").add_child(instanced);

"""
deleteRoom() removes the current scene located under the map child node, if there is one.
This has the effect of removing the currently loaded room from the game, as the map child node stores the
currently loaded room scene.
"""
func deleteRoom():
	var terminated = self.get_node("map").get_child(0);
	#print(terminated);
	if(terminated != null):
		terminated.queue_free();
	
"""
shiftRoom() takes a room scene (roomIndex) and swaps out the current room (via deleteRoom) with the given room (via spawn room).
The roomShiftTimer is then activated to prevent any accidental room shifting during the loading process.
"""
func shiftRoom(roomIndex):
	deleteRoom();
	spawnRoom(roomIndex);
	roomShiftTimer = roomShiftTime;

"""
boundryLegalCheck takes two integers, denoting coordinates on the floorplan.
boundryLegalCheck inspects if the given coordinates are within the bounds of the floorplan.
"""
func boundryLegalCheck(givenX, givenY):
	var floorplan = worldManagerNode.floorplanGeneratorNode.floorPlan;
	
	#Ensure in bounds on x plane
	if( (givenX < 0) or (givenX >= floorplan.size()) ):
		return false;

	#Ensure in bounds on y plane
	if( (givenY < 0) or (givenY >= floorplan[0].size()) ):
		return false;
	return true;

