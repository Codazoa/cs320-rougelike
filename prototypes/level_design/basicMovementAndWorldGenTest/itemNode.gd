extends Node

class_name itemNode

var itemID: int;
var xPos; #Stores where item was resting on X-axis
var yPos; #Stores where item was resting on Y-axis
func _init(givenItemID = -1, givenXPos = 0, givenYPos = 0):
	itemID = givenItemID;
	xPos = givenXPos;
	yPos = givenYPos;
func toString():
	return "itemID: "+str(itemID)+", xPos: "+str(xPos)+", yPos: "+str(yPos);
"""
This class mainly serves as a proof of concept on how item data could be stored in a room.
For example, when the player leaves a room, an item that was on the floor could be stored via this node,
and placed in the roomNode's records.
"""
