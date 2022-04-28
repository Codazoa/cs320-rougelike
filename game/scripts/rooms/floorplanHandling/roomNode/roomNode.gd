#All of the following code was written by Sydney Burgess
extends Node

class_name roomNode

var roomID: int;
var roomScene;
var roomLayoutFileName;
var roomCleared;
var persistantItemData = []; #Intended to be used later, when storing items that were dropped on the ground


func _init(givenRoomID = -1):
	roomID = givenRoomID;
	roomLayoutFileName = null;
	roomCleared = false;
	
"""
Simple getter function for managing the roomID var
"""
func getRoomID():
	return self.roomID;

"""
Simple setter function for managing the roomID var
"""
func setRoomID(givenRoomID):
	#print("Room set:"+str(roomID)); #Debug
	self.roomID = givenRoomID;

"""
Simple getter function for managing the roomScene var
"""	
func getRoomScene():
		return self.roomScene;

"""
Simple setter function for managing the roomScene var
"""
func setRoomScene(givenRoomScene):
	self.roomScene = givenRoomScene;

"""
This function goes unused, but served as a proof of concept on how to store items had they been
fully implemented
"""
func storeItem(itemID, xPos, yPos):
	persistantItemData.append(itemNode.new(itemID, xPos, yPos));

"""
This function goes unused, but served as a proof of concept on how to load stored items had they been
fully implemented
"""
func loadStoredItems():
	while(persistantItemData.size() > 0):
		print(persistantItemData[0].toString()); #Basic string display for now
		persistantItemData.remove(0); #Remove entry, as it would hypothetically be placed
