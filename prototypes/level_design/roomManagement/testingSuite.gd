extends Node

#=========
#Black box
#=========

# Called when the node enters the scene tree for the first time.
func _ready():
	floorPlan_findFirstDesiredBorderID();

#Test for proper width
func floorPlanWidthCheck():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(10, 7, 10);
	assert(floorPlan.floorPlan.size() == 10);

#Test for proper height
func floorPlanHeightCheck():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(10, 7, 10);
	assert(floorPlan.floorPlan[0].size() == 7);
	
#Test that spawn room exists
func floorPlanSpawnRoomExists():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(15, 15, 30);
	var spawnRoomCount = 0;
	for i in range(0, floorPlan.size()):
		for j in range(0, floorPlan[0].size()):
			if(floorPlan.floorPlan[i][j] == 2):
				spawnRoomCount +=1;
	assert(spawnRoomCount == 1);
	
	
#Test that boss room exists
func floorPlanBossRoomExists():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(15, 15, 30);
	var bossRoomCount = 0;
	for i in range(0, floorPlan.size()):
		for j in range(0, floorPlan[0].size()):
			if(floorPlan.floorPlan[i][j] == 3):
				bossRoomCount +=1;
	assert(bossRoomCount == 1);


	#============
	#Branch tests
	#============
func floorPlanIsRoomCheckCheck_outOfBoundsNegative():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlant(2,2);
	assert(floorPlan.roomIsRoomCheck(-9999, -9999) == 0); #Ensure coordinates that are out of bounds return false

func floorPlanIsRoomCheckCheck_outOfBoundsPositive():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlant(2,2);
	assert(floorPlan.roomIsRoomCheck(9999, 9999) == 0); #Ensure coordinates that are out of bounds return false
	
func floorPlanIsRoomCheckCheck_notRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlant(1,1);
	assert(floorPlan.roomIsRoomCheck(0, 0) == 0); #Ensure empty spot is classified as non-room

func floorPlanIsRoomCheckCheck_isRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlant(1,1);
	floorPlan.floorPlan[0][0].setRoomID(1); #Set the (only) spot to be a room
	assert(floorPlan.roomIsRoomCheck(0, 1) == 1); #Ensure room that has been set to be a room, is in fact a room.


#=========
#White box
#=========
func floorPlan_findFirstDesiredBorderID():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);
	
	#Check order for findFirstDesiredBordreID() is: up, down, left then right, then states none exist
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1)); #None/ no rooms exist
	
	floorPlan.floorPlan[1+1][1].setRoomID(1); #Add room to right
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1)); #Right / room to right
	
	floorPlan.floorPlan[1-1][1].setRoomID(1); #Add room to left
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1)); #Left / room to left
	
	floorPlan.floorPlan[1][1+1].setRoomID(1); #Add room below
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1)); #Down /room below
	
	floorPlan.floorPlan[1][1-1].setRoomID(1); #Add room above
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1)); #Up / room above
	
#================
#Integration test
#================
#Testing the merging of two classes/units. For example, Jack tested taking damage in one class, and then checking hp bar in other class
#
