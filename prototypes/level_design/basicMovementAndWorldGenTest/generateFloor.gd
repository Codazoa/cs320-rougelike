extends Node

export (PackedScene) var wall;

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
4 == etc.
"""

"""
roomIsRoomCheck() takes two integers denoting coordinates (givenX and givenY), and returns a boolean relating to whether or not
the room located at said coordinates is non-zero. (if non-zero, return true)
"""
func roomIsRoomCheck(givenX, givenY):
	if(!roomIsLegal(givenX, givenY)): return false;
	if(floorPlan[givenX][givenY] != 0): return true;
	return false;

"""
roomIsLegal() takes two integers denoting coordinates (givenX and givenY), and returns a boolean relating to
whether or not said coordinates are within bounds of the floorPlan array.
"""
func roomIsLegal(givenX, givenY):
	#Check if passed upper bounds
	if(givenY < 0): return false;
	
	#Check if passed lower bounds
	if(givenY >= floorPlan[0].size()-1): return false;	
	
	#Check if passed left bounds
	if(givenX < 0): return false;	
	
	#Check if passed right bounds
	if(givenX >= floorPlan.size()-1): return false;	
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
	if(roomIsLegal(givenX, givenY-1) && (floorPlan[givenX][givenY-1] == desiredBorderID) ): 
		coordinates.append(givenX);
		coordinates.append(givenY-1);
		return coordinates;
	#Lower
	if(roomIsLegal(givenX, givenY+1) &&  (floorPlan[givenX][givenY+1] == desiredBorderID) ):
		coordinates.append(givenX);
		coordinates.append(givenY+1);
		return coordinates;
	#Left
	if(roomIsLegal(givenX-1, givenY) &&  (floorPlan[givenX-1][givenY] == desiredBorderID) ) :
		coordinates.append(givenX-1);
		coordinates.append(givenY);
		return coordinates;
	#Right
	if(roomIsLegal(givenX+1, givenY) &&  (floorPlan[givenX+1][givenY] == desiredBorderID) ):
		coordinates.append(givenX+1);
		coordinates.append(givenY);
		return coordinates;
	coordinates.append(-1);
	return coordinates;

func findDeadendSpot(defaultRoomID, placementID):
	var legalRoomIDCheck = false;
	var legalBorderCheck = false;
	var fullLoopCheck = false;
	
	#Get random point using size of layout
	var chosenX = rng.randi_range(0, floorPlan.size()-1);
	var chosenY = rng.randi_range(0, floorPlan[0].size()-1);
	var originalX = chosenX;
	var originalY = chosenY;
	
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
		if(roomIsLegal(chosenX, chosenY) && ( floorPlan[chosenX][chosenY] == placementID) ): legalRoomIDCheck = true;
		
		#Check if spot has 1 bordering room
		legalBorderCheck = false;
		if(roomBorderCount(chosenX, chosenY) == 1):
			var result = findFirstDesiredBorderID(chosenX, chosenY, defaultRoomID);
			if( (result[0] != -1) && (floorPlan[result[0]][result[1]] == defaultRoomID) ): legalBorderCheck = true;
	
	#print("While loop completed. legalRoomIDCheck: "+str(legalRoomIDCheck)+", legalBorderCheck: "+str(legalBorderCheck)+", fullLoopCheck: "+str(fullLoopCheck));
	
	#Return final vals
	var chosenCoords = [];
	chosenCoords.append(chosenX);
	chosenCoords.append(chosenY);
	return chosenCoords;

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
	floorPlan[givenX][givenY] = 1;
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
			floorPlan[i][j] = 0;

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
	
	#Place room
	placeRoom( roomMarkerWidth, roomMarkerHeight, 0);

	#Ensure enough rooms are placed
	while(currentRoomCount < floorPlanRoomCount):
		#Locate random point in room to banch out of
		var selectedRoom = findDeadendSpot(1, 0); #Use special locate room function
		placeRoom( selectedRoom[0], selectedRoom[1], 0);
	
	#Place special rooms
	pass;

"""
DEBUG FUNCTION: Places tiles in accordance to floor plan
"""
func buildFloorPlan(event):
	var desiredWidth = floorPlan.size();
	var desiredHeight = floorPlan[0].size();
	
	#Iterate through array
	for i in range(0, desiredWidth):
		for j in range(0, desiredHeight):
			if(floorPlan[i][j] == 0):
				#Create instance
				var new_wall = wall.instance();
				#Grab sprite size
				var wallSprite = new_wall.get_node("StaticBody2D").get_node("SpriteTest");
				var wallWidth = wallSprite.texture.get_width()*wallSprite.scale.x;
				var wallHeight = wallSprite.texture.get_height()*wallSprite.scale.y;
				
				#Modify position
				new_wall.position.x = event.position.x+(i*wallWidth);
				new_wall.position.y = event.position.y+(j*wallHeight);
				add_child(new_wall);

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
DEBUG FUNCTION: _input spawns a wall at the cursor position if the left mouse button is clicked
"""
func _input(event):
	if (detectClick(event)):
		generateFloorPlan(7, 7, 10);
		buildFloorPlan(event);
