extends Node

var spawnRooms = [];
var genericRooms = [];
var treasureRooms = [];
var bossRooms = [];


# Called when the node enters the scene tree for the first time.
func _ready():
	generateDatabase();

func generateDatabase():
	print("Generating roomDatabase");
	loadGenericRooms();	

func loadGenericRooms():
	print("Loading generic rooms");
	var totalRooms = 4; #I don't like having a variable that dictates how many rooms to load but I don't know how to grab the count of files in the directory
	var tempRoom;
	for i in range(0, totalRooms):
		genericRooms.append(load("res://rooms/genericRooms/genericRoom_"+str(i)+".tscn"));
	tempRoom = genericRooms[0].instance();
	add_child(tempRoom);
	print("Finishing loading generic rooms.")

func pickRoom(roomType):
	var chosenRoom;
	chosenRoom = genericRooms[1];
	return chosenRoom;
