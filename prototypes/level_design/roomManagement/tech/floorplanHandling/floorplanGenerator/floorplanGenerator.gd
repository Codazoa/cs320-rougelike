#All of the following code was written by Sydney Burgess
extends Node

export (PackedScene) var wall;
export (PackedScene) var generalRoom;
export (PackedScene) var spawnRoom;
export (PackedScene) var bossRoom;

var worldManagerNode;

class_name generateFloor

var floorPlan = []; #Stores floor plan
var floorPlanWidth; #Handles width of floor plan
var floorPlanHeight; #Handles height of floor plan
var floorPlanRoomCount; #Handles how many desired rooms there will be in floor plan
var currentRoomCount; #Handles how many rooms have been created in the current floor plan
var rng = RandomNumberGenerator.new();

"""
RoomID:
	0 == no room
	1 == generic room
	2 == spawn room
	3 == exit/boss room
	4 == dot room
	5 == etc.
"""

"""
roomIsRoomCheck() takes two integers denoting coordinates (givenX and givenY), and returns a boolean relating to whether or not
the room located at said coordinates is non-zero. (if non-zero, return true)
"""
func roomIsRoomCheck(givenX, givenY):
	if(!roomIsLegal(givenX, givenY)): 
		return false;
	if(floorPlan[givenX][givenY].getRoomID() != 0): 
		return true;
	return false;

"""
roomIsLegal() takes two integers denoting coordinates (givenX and givenY), and returns a boolean relating to
whether or not said coordinates are within bounds of the floorPlan array.
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
roomBorderCount() takes two integers denoting coordinates (givenX and givenY), and returns an integer
denoting how many non-zero rooms are bordering the room at the given coordinates.
"""
func roomBorderCount(givenX, givenY):
	var borderingRooms = 0;
	#Upper
	if(roomIsLegal(givenX, givenY-1) && roomIsRoomCheck(givenX, givenY-1) ): borderingRooms += 1;
	#Lower
	if(roomIsLegal(givenX, givenY+1) && roomIsRoomCheck(givenX, givenY+1)): borderingRooms += 1;
	#Left
	if(roomIsLegal(givenX-1, givenY) && roomIsRoomCheck(givenX-1, givenY) ) : borderingRooms += 1;
	#Right
	if(roomIsLegal(givenX+1, givenY) && roomIsRoomCheck(givenX+1, givenY) ): borderingRooms += 1;
	return borderingRooms;

"""
findFirstDesiredBorderID() takes three integers denoting coordinates (givenX and givenY) and a desiredBorderID.
findFirstDesiredBorderID() scans the cardinal directions around the given coordinates, and returns the coordinates
of the first instance it can find of desiredBorderID. If it cannot be found, a 1d array is returned containing -1.
"""
func findFirstDesiredBorderID(givenX, givenY, desiredBorderID):
	var coordinates = [];
	#Upper
	if(roomIsLegal(givenX, givenY-1) && (floorPlan[givenX][givenY-1].getRoomID() == desiredBorderID) ): 
		coordinates.append(givenX);
		coordinates.append(givenY-1);
		return coordinates;
	#Lower
	if(roomIsLegal(givenX, givenY+1) &&  (floorPlan[givenX][givenY+1].getRoomID() == desiredBorderID) ):
		coordinates.append(givenX);
		coordinates.append(givenY+1);
		return coordinates;
	#Left
	if(roomIsLegal(givenX-1, givenY) &&  (floorPlan[givenX-1][givenY].getRoomID() == desiredBorderID) ) :
		coordinates.append(givenX-1);
		coordinates.append(givenY);
		return coordinates;
	#Right
	if(roomIsLegal(givenX+1, givenY) &&  (floorPlan[givenX+1][givenY].getRoomID() == desiredBorderID) ):
		coordinates.append(givenX+1);
		coordinates.append(givenY);
		return coordinates;
	coordinates.append(-1);
	return coordinates;

"""
findDeadendRoom() takes two integers. The first integer denotes what roomID should be checked when checking for a
deadend. In most cases '0' will be utilized here. The second integer placementID denotes what roomID the deadend should be of.
"""
func findDeadendRoom(defaultRoomID, placementID):
	var legalRoomIDCheck = false;
	var legalBorderCheck = false;
	var fullLoopCheck = false;
	
	#Get random point using size of layout
	var chosenX = rng.randi_range(0, floorPlan.size()-1);
	var chosenY = rng.randi_range(0, floorPlan[0].size()-1);
	
	#Parse until conditions are met
	while( (!legalRoomIDCheck || !legalBorderCheck) || fullLoopCheck ):
		#Shift x over by 1
		chosenX += 1;
		
		#Account for overflow
		if(chosenX == floorPlan.size()):
			chosenX = 0;
			chosenY += 1;
		if(chosenY == floorPlan[0].size()):
			chosenY = 0;
		
		#Check if array has been fully scanned
		fullLoopCheck = 0; #( (chosenX == originalX) && (chosenY == originalY) );
	
		#Check if legal roomID, and if room is of placementID
		legalRoomIDCheck = false;
		var legalPlacementFoundCheck = roomIsLegal(chosenX, chosenY) && ( floorPlan[chosenX][chosenY].getRoomID() == placementID);
		if( legalPlacementFoundCheck ): legalRoomIDCheck = true;
		
		#Check if spot has 1 bordering room
		legalBorderCheck = false;
		if(roomBorderCount(chosenX, chosenY) == 1):
			var result = findFirstDesiredBorderID(chosenX, chosenY, defaultRoomID);
			if( (result[0] != -1) && (floorPlan[result[0]][result[1]].getRoomID() == defaultRoomID) ): legalBorderCheck = true;
	
	#print("While loop completed. legalRoomIDCheck: "+str(legalRoomIDCheck)+", legalBorderCheck: "+str(legalBorderCheck)+", fullLoopCheck: "+str(fullLoopCheck));
	
	#Return final vals
	var chosenCoords = [];
	chosenCoords.append(chosenX);
	chosenCoords.append(chosenY);
	return chosenCoords;

"""
findAllDeadendRooms() returns a 2d array of integers, denoting the coordinates of all dead end rooms
on the current floor plan. These deadend rooms are classified via roomIs(RoomCheck(), alongside receiving
1 from roomBorderCount().
"""
func findAllDeadendRooms():
	var coordRecord = []; #Will be used to store all coords found
	#Cycle through entire floorplan
	for i in range(0, floorPlan.size()):
		for j in range(0, floorPlan[0].size()):
			#Check if non-zero room found, along with if room only has 1 bordering room.
			if( roomIsRoomCheck(i, j) and (roomBorderCount( i, j) == 1) ):
				var coords = []; #Will be used to find coordinates just found. Then appended ot coordRecord
				coords.append(i);
				coords.append(j);
				coordRecord.append(coords); #If 3 bordering walls, record location
	#Return array
	return coordRecord;

"""
placeRoom() is a recursive function that takes three integers. The first two parameters denote the x and y coordinates
to attempt to place a room at. The third integer denotes the current 'depth' placeRoom() is at.
placeRoom() completes the following actions:
	-Ensure the current rooms generated on the floorplan has not exceeded the desired total rooms
	-Ensure the currentDepth parameter given does not exceed a defined maximum depth. Depth is defined as the 'distance'
	away from the original calling location of placeRoom(). This is done to discourage the floorplan generating in a straight line.
	-Ensure the given coordinates point towards a legitimate location on the floorplan (not out of bounds). Uses roomisLegal()
	-Using roomIsRoomCheck(), checks to ensure given coordinates do not point towards a pre-exisitng room.
	-Using roomBorderCount(), ensures current coordinates would not generate a room at a location with too many adjacent rooms
	-50/50 chance to place room at current location. 50/50 chance is overridded if no roomes are placed yet.
	-Place room. Increment room count
	-Then, call placeRoom() on all surrounding room coordinates in a semi-random order.
"""
func placeRoom(givenX, givenY, currentDepth):
	var adjacentLimit = 1;
	var maxDepth = 2;
	if(currentRoomCount >= floorPlanRoomCount): return -1; #Ensures room count does not exceed desired count
	if( (currentDepth >= maxDepth ) && (floorPlanRoomCount > 2) ): return -1; #Discourages long passages from generating
	if(!roomIsLegal(givenX, givenY)): return -1; #Prevents room from being generated in illegal location (out of bounds)
	if(roomIsRoomCheck(givenX, givenY)): return -1; #Prevents room from being generated over pre-existing room
	if(roomBorderCount(givenX, givenY) > adjacentLimit): return -1; #Check if room will have more bordering rooms than desired
	if( (rng.randi_range(0, 100) < 50) && (currentRoomCount > 1) ): return -1; #Random chance to not place room
	
	#Place room
	floorPlan[givenX][givenY].setRoomID(1);
	currentRoomCount += 1;

	#Recurse on all cardinally adjacent rooms (in semi-random order)
	var counter = rng.randi_range(0,3); #Pick a random starting direction
	for i in range(0, 4):
		counter +=1; #Get new direction
		if(counter > 4): counter = 0; #Reset to 0 if a full directional rotation is made

		#Recurse in current direction
		match counter:
			0:
				placeRoom(givenX-1, givenY, currentDepth+1); #North
			1:
				placeRoom(givenX+1, givenY, currentDepth+1); #South
			2:
				placeRoom(givenX, givenY-1, currentDepth+1); #East
			3:
				placeRoom(givenX, givenY+1, currentDepth+1); #West

"""
Generates an "empty" array for use in generateFloorPlan(). Takes two integers denoting the width and height or the array
"""
func createEmptyFloorPlan(givenFloorPlanWidth, givenFloorPlanHeight):
	floorPlan = []; #Clear previosu stored plan, if one exists
	
	for i in range(0, givenFloorPlanWidth):
		floorPlan.append([]);
		for j in range(0, givenFloorPlanHeight):
			floorPlan[i].append([]);
			floorPlan[i][j] = roomNode.new(0);

"""
Generates a floor plan and places it in the variable floorPlan. Takes three integers, denoting the width and height of the floor plan, and the desired number of rooms in the floorplan
"""
func generateFloorPlan(givenFloorPlanWidth, givenFloorPlanHeight, givenFloorPlanRoomCount):
	var floorPlanWidth = givenFloorPlanWidth;
	var floorPlanHeight = givenFloorPlanHeight;
	floorPlanRoomCount = givenFloorPlanRoomCount;
	
	currentRoomCount = 0;
	var adjacentLimit = 1;
	var roomMarkerWidth = int(floorPlanWidth/2);
	var roomMarkerHeight = int(floorPlanHeight/2);
	
	#Initialize floorplan array
	createEmptyFloorPlan(floorPlanWidth, floorPlanHeight);
	
	#Place initial room, which begins process of "growing" dungeon
	placeRoom( roomMarkerWidth, roomMarkerHeight, 0);

	#Ensure enough rooms are placed
	while(currentRoomCount < floorPlanRoomCount):
		#Locate random point in room to banch out of
		var selectedRoom = findDeadendRoom(1, 0); #Use special locate dead end room function
		placeRoom( selectedRoom[0], selectedRoom[1], 0);
	
	#Place special rooms
	var chosenIndex;
	var deadendCoords = findAllDeadendRooms();

		#Place spawn room
	chosenIndex = rng.randi_range(0, deadendCoords.size()-1); #Choose random index from list of deadends
	var spawnRoomCoords = deadendCoords[chosenIndex]; #Records coordinates at index for later
	deadendCoords.remove(chosenIndex); #Remove coordinates from list
	floorPlan[spawnRoomCoords[0]][spawnRoomCoords[1]].setRoomID(2); #Place spawn room

		#Place boss room
	#Cycle through entire deadendCoords list
	var bossRoomCoordsIndex = findFurthestDeadEnd(spawnRoomCoords, deadendCoords);
	floorPlan[deadendCoords[bossRoomCoordsIndex][0]][deadendCoords[bossRoomCoordsIndex][1]].setRoomID(3);

"""
findFurthestDeadEnd() takes two parameters, the first is an integer array that denotes the coordinates of a room 
on the current floorplan. The second parameter is a 2d integer array which denotes a list of coordinates that point 
towards deadend rooms on the floor plan. An integer denoting the index of the coordinates furthest from the given 
coordinats will be returned. The index is returned to allow for future removal of the coordinates from the list if 
need be.
"""
func findFurthestDeadEnd(givenCoordinates, givenDeadendCoords):
	var anchorVector = Vector2(givenCoordinates[0], givenCoordinates[1]);
	var furthestCoordsIndex = 0;
	for i in range(0, givenDeadendCoords.size()-1):
		#Get distance between current point and 
		var currentDist = anchorVector.distance_to(Vector2(givenDeadendCoords[i][0], givenDeadendCoords[i][1]));
		var furthestDist = anchorVector.distance_to(Vector2(givenDeadendCoords[furthestCoordsIndex][0], givenDeadendCoords[furthestCoordsIndex][1]));
		if(currentDist > furthestDist): 
			furthestCoordsIndex = i;
	return furthestCoordsIndex;

"""
DEBUG FUNCTION: Places tile according to room for help in building floor plan
"""
func placeObject(event, givenInstance, i, j):
	#Grab sprite size
	var instanceSprite = givenInstance.get_node("StaticBody2D").get_node("SpriteTest");
	var spriteWidth = instanceSprite.texture.get_width()*instanceSprite.scale.x;
	var spriteHeight = instanceSprite.texture.get_height()*instanceSprite.scale.y;
		
	#Modify position
	givenInstance.position.x = event.position.x+(i*spriteWidth);
	givenInstance.position.y = event.position.y+(j*spriteHeight);
	add_child(givenInstance);


"""
DEBUG FUNCTION: Places tiles in accordance to floor plan to allow for visualization of map
"""
func buildFloorPlan(event):
	var desiredWidth = floorPlan.size();
	var desiredHeight = floorPlan[0].size();
	
	#Iterate through array
	for i in range(0, desiredWidth):
		for j in range(0, desiredHeight):
			var new_instance = -1;
			#Identify what room id is
			if(floorPlan[i][j].getRoomID() == 1): 
				placeObject(event, generalRoom.instance(), i, j);
				pass;
			elif(floorPlan[i][j].getRoomID() == 2):
				placeObject(event, spawnRoom.instance(), i, j);
			elif(floorPlan[i][j].getRoomID() == 3):
				placeObject(event, bossRoom.instance(), i, j);
			else:
				placeObject(event, wall.instance(), i, j);
"""
DEBUG FUNCTION: detectClick is a basic function that checks for a left click input. It returns a true/false boolean. It
was intended for me to test out mouse inputs, as well as practicing function formatting in godot.
"""
func detectClick(event):
		if(event is InputEventMouseButton):
			if((event.button_index == BUTTON_LEFT) and (event.pressed)):
				return true;
		return false;

"""
DEBUG FUNCTION: _input spawns a the floor plan, starting at the cursor position (if the left mouse button is clicked)
"""
func _input(event):
	if (detectClick(event)):
		generateFloorPlan(15, 15, 30);
		buildFloorPlan(event);


func _ready():
		print("Node created: floorplanGenerator");
