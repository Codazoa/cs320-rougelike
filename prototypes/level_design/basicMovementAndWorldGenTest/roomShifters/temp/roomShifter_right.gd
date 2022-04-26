#All of the following code was written by Sydney Burgess
extends Node2D
var xShift = 1;
var yShift = 0;

var roomTileWidth = 9;
var roomTileHeight = 9;

export (PackedScene) var scene;

func grabSpriteSize(target, desiredDimension):
	var instanceSprite = target.get_node("SpriteTest");
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
	var roomLayoutNode = get_tree().get_root().get_node("masterNode").find_node("roomLayout")
	roomLayoutNode.get_child(0).queue_free();
	
	#Spawn next room
	var roomScene = scene.instance();
	roomLayoutNode.add_child(roomScene);
	
	collider.global_position.x = self.global_position.x-(grabSpriteSize(self, true)*(roomTileWidth-2));
	collider.global_position.y = self.global_position.y;
