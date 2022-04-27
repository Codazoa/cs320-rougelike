extends "res://addons/gut/test.gd"

var floorPlanGenerator = load("res://scripts/rooms/floorplanHandling/floorplanGenerator/floorplanGenerator.gd");
var roomDatabase = load("res://scenes/rooms/roomTech/roomDatabase/roomDatabase.tscn");
var roomShifter = load("res://scenes/rooms/roomTech/roomShifter/roomShifter.tscn");

#=========
#Black box/acceptance tests
#=========

#Test for proper width
func test_floorPlanWidthCheck():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(10, 7, 10);
	assert_eq(floorPlan.floorPlan.size(), 10, "floorPlan width did not match parameters!");

#Test for proper height
func test_floorPlanHeightCheck():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(10, 7, 10);
	assert_eq(floorPlan.floorPlan[0].size(), 7, "floorPlan's height did not meet parameters!");
	
#Test that spawn room exists
func test_floorPlanSpawnRoomExists():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(15, 15, 30);
	var spawnRoomCount = 0;
	for i in range(0, floorPlan.floorPlan.size()):
		for j in range(0, floorPlan.floorPlan[0].size()):
			if(floorPlan.floorPlan[i][j].getRoomID() == 2):
				spawnRoomCount +=1;
	assert_eq(spawnRoomCount, 1, "Spawn room count did not equal 1!");
	
	
#Test that boss room exists
func test_floorPlanBossRoomExists():
	var floorPlan = generateFloor.new();
	floorPlan.generateFloorPlan(15, 15, 30);
	var bossRoomCount = 0;
	for i in range(0, floorPlan.floorPlan.size()):
		for j in range(0, floorPlan.floorPlan[0].size()):
			if(floorPlan.floorPlan[i][j].getRoomID() == 3):
				bossRoomCount +=1;
	assert_eq(bossRoomCount, 1, "Boss room count did not equal 1!");


	#============
	#Branch tests
	#============
"""
func roomIsLegal(givenX, givenY):
	#Check if passed upper bounds
	if(givenY < 0): 
		return false;
	
	#Check if passed lower bounds
	if(givenY >= floorPlan[0].size()-1): 
		return false;	
	
	#Check if passed left bounds
	if(givenX < 0): 
		return false;	
	
	#Check if passed right bounds
	if(givenX >= floorPlan.size()-1): 
		return false;	
	return true;
"""
func test_floorPlanIsRoomCheckCheck_outOfBoundsNegative():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(2,2);
	assert_false(floorPlan.roomIsRoomCheck(-9999, -9999), "Negative out of bounds parameters returned true!"); #Ensure coordinates that are out of bounds return false

func test_floorPlanIsRoomCheckCheck_outOfBoundsPositive():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(2,2);
	assert_false(floorPlan.roomIsRoomCheck(9999, 9999), "Positive out of bounds parameters returned true!"); #Ensure coordinates that are out of bounds return false
	
func test_floorPlanIsRoomCheckCheck_notRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(1,1);
	assert_false(floorPlan.roomIsRoomCheck(0, 0), "Empty spot was classified as room!"); #Ensure empty spot is classified as non-room

func floorPlanIsRoomCheckCheck_isRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(1,1);
	floorPlan.floorPlan[0][0].setRoomID(1); #Set the (only) spot to be a room
	assert_true(floorPlan.roomIsRoomCheck(0, 1), "Room at given coordinates was not recognized as a room!"); #Ensure room that has been set to be a room, is in fact a room.


#=========
#White box
#=========
#All of the test_floorPlan_findFirstDesiredBorderID() test functions collectively provide branch coverage over the findFirstDesiredBorderID function.
func test_floorPlan_findFirstDesiredBorderID_noRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);
	
	#Check order for findFirstDesiredBordreID() is: up, down, left then right, then states none exist
	assert_eq(floorPlan.findFirstDesiredBorderID(1, 1, 1), [-1], "Room coordinates were found when no room exists!");
	
func test_floorPlan_findFirstDesiredBorderID_rightRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);

	floorPlan.floorPlan[1+1][1].setRoomID(1); #Add room to right
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1));
	assert_eq(floorPlan.findFirstDesiredBorderID(1, 1, 1), [2,1], "Proper coordinates to right room were not obtained!"); #Right / room to right
	
func test_floorPlan_findFirstDesiredBorderID_leftRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);

	
	floorPlan.floorPlan[1+1][1].setRoomID(1); #Add room to right
	floorPlan.floorPlan[1-1][1].setRoomID(1); #Add room to left
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1));
	assert_eq(floorPlan.findFirstDesiredBorderID(1, 1, 1), [0,1], "Proper coordinates to left room were not obtained!"); #Left / room to left
	
func test_floorPlan_findFirstDesiredBorderID_downRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);
	
	floorPlan.floorPlan[1+1][1].setRoomID(1); #Add room to right
	floorPlan.floorPlan[1-1][1].setRoomID(1); #Add room to left
	floorPlan.floorPlan[1][1+1].setRoomID(1); #Add room below
	print(floorPlan.findFirstDesiredBorderID(1, 1, 1));
	assert_eq(floorPlan.findFirstDesiredBorderID(1, 1, 1), [1,2], "Proper coordinates to lower room were not obtained!");
	
func test_floorPlan_findFirstDesiredBorderID_upRoom():
	var floorPlan = generateFloor.new();
	floorPlan.createEmptyFloorPlan(4, 4);
	
	floorPlan.floorPlan[1+1][1].setRoomID(1); #Add room to right
	floorPlan.floorPlan[1-1][1].setRoomID(1); #Add room to left
	floorPlan.floorPlan[1][1+1].setRoomID(1); #Add room below
	floorPlan.floorPlan[1][1-1].setRoomID(1); #Add room above
	assert_eq(floorPlan.findFirstDesiredBorderID(1, 1, 1), [1,0], "Proper coordinates to upper room were not obtained!");
	
#================
#Integration test
#================
#This took a big-bang approach. This test ensures that rooms are properly picked/provided when asked in the roomShifterNode. The roomShifterNode
#does not hold any data on rooms, and as such must as for a room from the roomDataBaseNode. Due to these functions providing random rooms,
#all possible rooms must be checked for instead of just a fixed room. This test kind of sucks cause adding more rooms will break it, 
#but its more to prove the two nodes communicate with each other effectively.

#roomShifterNode's pickRoom():
"""
func pickRoom(roomType):
	return roomDatabaseNode.pickRoom(roomType);
"""

#roomDatabaseNode's pickRoom():
"""
func pickRoom(roomType):
	#Generic Rooms
	if(roomType == 1):
		return genericRooms[rng.randi_range(0, genericRooms.size()-1)];
	#Spawn Rooms
	elif(roomType == 2):
		return spawnRooms[rng.randi_range(0, spawnRooms.size()-1)];
	#Boss Rooms
	elif(roomType == 3):
		return bossRooms[rng.randi_range(0, bossRooms.size()-1)];
	#Dot Rooms
	elif(roomType == 4):
		return dotRooms[rng.randi_range(0, dotRooms.size()-1)];
	#Default/failsafe
	else:
		return genericRooms[0];
"""
#
func test_pickRoom():
	var roomDatabaseNode = roomDatabase.instance();
	var roomShifterNode = roomShifter.instance();
	roomDatabaseNode.generateDatabase(); #Load all scenes into database
	var pickResult = roomDatabaseNode.pickRoom(1);
	var check = ( (pickResult == roomDatabaseNode.grabRoom(1, 0)) or (pickResult == roomDatabaseNode.grabRoom(1, 1) ) );
	
	assert_true(check, "Correct room was not obtained!");
