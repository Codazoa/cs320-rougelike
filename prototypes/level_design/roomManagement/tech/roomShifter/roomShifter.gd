#All of the following code was written by Sydney Burgess
extends Node2D
var xShift = 0;
var yShift = 1;
var shifterType; #0 == left, 1 == right, 2 == up, 3 == down

var roomTileWidth = 9;
var roomTileHeight = 9;

var worldManagerNode;

export (PackedScene) var scene;

func grabSpriteSize(desiredDimension):
	var instanceSprite = self.get_node("SpriteTest");
	if(desiredDimension):
		return instanceSprite.texture.get_width()*instanceSprite.scale.x;
	#Height
	else:
		return instanceSprite.texture.get_height()*instanceSprite.scale.y;


"""
handleCollision() is a function where any checks that might occur before shifting a room take place.
For example, if the player is not allowed to leave the room yet, said check could be placed here.
"""
func handleCollision(collider):
	if(true): #Hypothetical case where I could check for if player is allowed to leave the room yet
		shiftRoom(collider);

"""
shiftRoom() takes one argument, that being the node that collided with the roomShifter.
shiftRoom() serves mainly as a method of testing coordinate manipulation. Each version of the roomShifter
has varying effects on objects in the room.
"""
func shiftRoom(collider):
	#get_tree().get_root().get_node("Node2D").get_node("roomLayout").get_node("map").queue_free();
	#get_tree().get_root().get_node("masterNode").find_node("map").queue_free();
	
	#Delete previous room
	var roomLayoutNode = get_tree().get_root().get_node("mainNode").find_node("worldManager").roomLayoutNode;
	print(roomLayoutNode)
	var terminated = roomLayoutNode.get_node("map").get_child(0)
	print(terminated);
	terminated.queue_free();
	
	#Spawn next room
	var roomScene = pickRoom(0).instance();
	roomLayoutNode.get_node("map").add_child(roomScene);
	
	#Shift collider to correct position
	match shifterType:
		#Left
		0:
			collider.global_position.x = self.global_position.x+(grabSpriteSize(true)*(roomTileWidth-2));
			collider.global_position.y = self.global_position.y;
		
		#Right
		1:
			collider.global_position.x = self.global_position.x-(grabSpriteSize(true)*(roomTileWidth-2));
			collider.global_position.y = self.global_position.y;
		
		#Up
		2:
			collider.global_position.x = self.global_position.x;
			collider.global_position.y = self.global_position.y+(grabSpriteSize(false)*(roomTileHeight-2));

		#Down
		3:
			collider.global_position.x = self.global_position.x;
			collider.global_position.y = self.global_position.y-(grabSpriteSize(false)*(roomTileHeight-2));

"""
pickRoom() takes an integer denoting roomType, and returns a random room scene for said type of room.
This function effectively just pipes the given request to the roomDatabase node, which produces a scene
and passes it back.
"""
func pickRoom(roomType):
	var roomDatabase = get_tree().get_root().get_node("mainNode").find_node("worldManager").roomDatabaseNode;
	return roomDatabase.pickRoom(roomType);
