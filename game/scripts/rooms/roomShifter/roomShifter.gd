#All of the following code was written by Sydney Burgess
extends Node2D
var shifterType; #0 == left, 1 == right, 2 == up, 3 == down

var roomTileWidth = 17;
var roomTileHeight = 9;

var worldManagerNode;

export (PackedScene) var scene;

var doorSprite = preload("res://assets/roomIcons/spr_relocator.png");
var wallSprite = preload("res://assets/roomIcons/spr_userInterface_invIcon_0.png");

func grabSpriteSize(desiredDimension):
	var instanceSprite = self.get_node("SpriteTest");
	if(desiredDimension):
		return 8*instanceSprite.texture.get_width()*instanceSprite.scale.x;
	#Height
	else:
		return 8*instanceSprite.texture.get_height()*instanceSprite.scale.y;


"""
handleCollision() is a function where any checks that might occur before shifting a room take place.
For example, if the player is not allowed to leave the room yet, said check could be placed here. Currently
it checks if the player is attempting to go out of bounds, and or if the player is attempting to walk into a
non-existant room.
"""
func handleCollision(collider):
	var shiftTimerCheck = (worldManagerNode.roomLayoutNode.roomShiftTimer == -1);
	#Check if at boundries
	var boundryLegalCheck;
	var legalRoomCheck;
	match shifterType:
		#Left
		0:
			boundryLegalCheck = worldManagerNode.roomLayoutNode.boundryLegalCheck(worldManagerNode.currentLocationX-1, worldManagerNode.currentLocationY);
			legalRoomCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX-1, worldManagerNode.currentLocationY);
		#Right
		1:
			boundryLegalCheck = worldManagerNode.roomLayoutNode.boundryLegalCheck(worldManagerNode.currentLocationX+1, worldManagerNode.currentLocationY);
			legalRoomCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX+1, worldManagerNode.currentLocationY);
		#Up
		2:
			boundryLegalCheck = worldManagerNode.roomLayoutNode.boundryLegalCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY-1);
			legalRoomCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY-1);
		#Down
		3:
			boundryLegalCheck = worldManagerNode.roomLayoutNode.boundryLegalCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY+1);
			legalRoomCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY+1);

	if(boundryLegalCheck && legalRoomCheck && shiftTimerCheck): #Hypothetical case where I could check for if player is allowed to leave the room yet
		shiftRoom(collider);

"""
shiftRoom() takes one argument, that being the node that collided with the roomShifter.
shiftRoom() serves mainly as a method of testing coordinate manipulation. Each version of the roomShifter
has varying effects on objects in the room.
"""
func shiftRoom(collider):
	
	#Shift collider to correct position
	match shifterType:
		#Left
		0:
			collider.global_position.x = self.global_position.x+(grabSpriteSize(true)*(roomTileWidth-2));
			collider.global_position.y = self.global_position.y;
			
			worldManagerNode.currentLocationX += -1;
			worldManagerNode.currentLocationY += 0;
			
			print("Location: ("+str(worldManagerNode.currentLocationX)+", "+str(worldManagerNode.currentLocationY)+")");
		
		#Right
		1:
			collider.global_position.x = self.global_position.x-(grabSpriteSize(true)*(roomTileWidth-2));
			collider.global_position.y = self.global_position.y;
			
			worldManagerNode.currentLocationX += 1;
			worldManagerNode.currentLocationY += 0;
			
			print("Location: ("+str(worldManagerNode.currentLocationX)+", "+str(worldManagerNode.currentLocationY)+")");
		
		#Up
		2:
			collider.global_position.x = self.global_position.x;
			collider.global_position.y = self.global_position.y+(grabSpriteSize(false)*(roomTileHeight-2));
			
			worldManagerNode.currentLocationX += 0;
			worldManagerNode.currentLocationY += -1;
			
			print("Location: ("+str(worldManagerNode.currentLocationX)+", "+str(worldManagerNode.currentLocationY)+")");

		#Down
		3:
			collider.global_position.x = self.global_position.x;
			collider.global_position.y = self.global_position.y-(grabSpriteSize(false)*(roomTileHeight-2));
			
			worldManagerNode.currentLocationX += 0;
			worldManagerNode.currentLocationY += 1;
			
			print("Location: ("+str(worldManagerNode.currentLocationX)+", "+str(worldManagerNode.currentLocationY)+")");

	collider.rebuild_body()
	
	var newScene = worldManagerNode.floorplanGeneratorNode.floorPlan[worldManagerNode.currentLocationX][worldManagerNode.currentLocationY].getRoomScene();
	worldManagerNode.roomLayoutNode.shiftRoom(newScene);

"""
pickRoom() takes an integer denoting roomType, and returns a random room scene for said type of room.
This function effectively just pipes the given request to the roomDatabase node, which produces a scene
and passes it back.
"""
func pickRoom(roomType):
	var roomDatabase = worldManagerNode.roomDatabaseNode;
	return roomDatabase.pickRoom(roomType);

func _process(delta):
	var roomExistsCheck = false;
	match shifterType:
		#Left
		0:
			roomExistsCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX-1, worldManagerNode.currentLocationY);
		#Right
		1:
			roomExistsCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX+1, worldManagerNode.currentLocationY);
		#Up
		2:
			roomExistsCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY-1);
		#Down
		3:
			roomExistsCheck = worldManagerNode.floorplanGeneratorNode.roomIsRoomCheck(worldManagerNode.currentLocationX, worldManagerNode.currentLocationY+1);

	if(roomExistsCheck):
		$SpriteTest.texture = doorSprite;
	else:
		$SpriteTest.texture = wallSprite;
