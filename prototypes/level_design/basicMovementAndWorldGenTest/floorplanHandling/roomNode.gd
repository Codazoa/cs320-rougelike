extends Node

class_name roomNode

var roomID: int;
var roomLayoutFileName;
var roomCleared;
var persistantItemData = []; #Intended to be used later, when storing items that were dropped on the ground

func _init(givenRoomID = -1):
	roomID = givenRoomID;
	roomLayoutFileName = null;
	roomCleared = false;
	
func getRoomID():
	return self.roomID;

func setRoomID(givenRoomID):
	#print("Room set:"+str(roomID)); #Debug
	self.roomID = givenRoomID;

func storeItem(itemID, xPos, yPos):
	persistantItemData.append(itemNode.new(itemID, xPos, yPos));

func loadStoredItems():
	while(persistantItemData.size() > 0):
		print(persistantItemData[0].toString()); #Basic string display for now
		persistantItemData.remove(0); #Remove entry, as it would hypothetically be placed
