extends Node2D
var xShift = 0;
var yShift = -1;
export (PackedScene) var scene;

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
	var roomScene = scene.instance();
	roomScene.position.x = 50;
	roomScene.position.y = 50;
	collider.position.x = self.position.x;
	collider.position.y = self.position.y+30;
	add_child(roomScene);
