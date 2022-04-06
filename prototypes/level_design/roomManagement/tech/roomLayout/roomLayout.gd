extends Node

var worldManagerNode;
var roomShiftTimer = -1;
var roomShiftTime = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	#print("Node created: roomLayout");
	#spawnRoom(2, 0);

func _process(delta):
	if(roomShiftTimer != -1):
		roomShiftTimer -= 1;
		#if(roomShiftTimer < -1): roomShiftTimer = -1;
	
func spawnRoom(roomScene):
	var instanced = roomScene.instance();
	self.get_node("map").add_child(instanced);

func deleteRoom():
	var terminated = self.get_node("map").get_child(0);
	#print(terminated);
	if(terminated != null):
		terminated.queue_free();
	
func shiftRoom(roomIndex):
	deleteRoom();
	spawnRoom(roomIndex);
	roomShiftTimer = roomShiftTime;

func boundryLegalCheck(givenX, givenY):
	var floorplan = worldManagerNode.floorplanGeneratorNode.floorPlan;
	
	#Ensure in bounds on x plane
	if( (givenX < 0) or (givenX >= floorplan.size()) ):
		return false;

	#Ensure in bounds on y plane
	if( (givenY < 0) or (givenY >= floorplan[0].size()) ):
		return false;
	return true;

