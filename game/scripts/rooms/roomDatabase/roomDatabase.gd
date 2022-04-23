extends Node

var rng = RandomNumberGenerator.new()

var spawnRooms = [];
var genericRooms = [];
var treasureRooms = [];
var bossRooms = [];
var dotRooms = [];

var worldManagerNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Node created: roomDatabase");
	generateDatabase();


"""
generateDatabase() fills/loads all room scenes into a database for later use.
"""
func generateDatabase():
	print("Generating roomDatabase");
	loadGenericRooms();	
	loadSpawnRooms();	
	loadBossRooms();	
	loadDotRooms();

"""
loadGenericRooms() loads all generic rooms located under a specific folder.
"""
func loadGenericRooms():
	print("Loading generic rooms");
	var totalRooms = 4; #I don't like having a variable that dictates how many rooms to load but I don't know how to grab the count of files in the directory
	for i in range(0, totalRooms):
		genericRooms.append(load("res://scenes/rooms/genericRooms/genericRoom_"+str(i)+".tscn"));
	print("Finishing loading generic rooms.");

"""
loadSpawnRooms() loads all spawn rooms located under a specific folder.
"""
func loadSpawnRooms():
	print("Loading spawn rooms");
	var totalRooms = 1; #I don't like having a variable that dictates how many rooms to load but I don't know how to grab the count of files in the directory
	for i in range(0, totalRooms):
		spawnRooms.append(load("res://scenes/rooms/spawnRooms/spawnRoom_"+str(i)+".tscn"));
	print("Finishing loading spawn rooms.");

"""
loadBossRooms() loads all boss rooms located under a specific folder.
"""
func loadBossRooms():
	print("Loading boss rooms");
	var totalRooms = 1; #I don't like having a variable that dictates how many rooms to load but I don't know how to grab the count of files in the directory
	for i in range(0, totalRooms):
		bossRooms.append(load("res://scenes/rooms/bossRooms/bossRoom_"+str(i)+".tscn"));
	print("Finishing loading boss rooms.");
	
"""
loadDotRooms() loads all dot rooms located under a specific folder.
"""
func loadDotRooms():
	print("Loading dot rooms");
	var totalRooms = 1; #I don't like having a variable that dictates how many rooms to load but I don't know how to grab the count of files in the directory
	for i in range(0, totalRooms):
		dotRooms.append(load("res://scenes/rooms/dotRooms/dotRoom_"+str(i)+".tscn"));
	print("Finishing loading dot rooms.");

"""
pickRoom() takes an integer denoting the roomType. It then returns a random scene from said roomType's
array of scenes.
"""
func pickRoom(roomType):
	#Generic Rooms
	if(roomType == 1):
		return genericRooms[rng.randi_range(0, genericRooms.size()-1)];
	#Spawn Rooms
	elif(roomType == 2):
		return spawnRooms[rng.randi_range(0, spawnRooms.size()-1)];
	#Boss Rooms
	elif(roomType == 3):
		return bossRooms[rng.randi_range(0, bossRooms.size()-1)];
	#Dot Rooms
	elif(roomType == 4):
		return dotRooms[rng.randi_range(0, dotRooms.size()-1)];
	#Default/failsafe
	else:
		return genericRooms[0];

"""
pickRoomIndex() takes an integer denoting the roomType. It then returns a random scene from said roomType's
array of scenes.
"""
func pickRoomIndex(roomType):
	#Generic Rooms
	if(roomType == 1):
		return genericRooms[rng.randi_range(0, genericRooms.size()-1)];
	#Spawn Rooms
	elif(roomType == 2):
		return spawnRooms[rng.randi_range(0, spawnRooms.size()-1)];
	#Boss Rooms
	elif(roomType == 3):
		return bossRooms[rng.randi_range(0, bossRooms.size()-1)];
	#Dot Rooms
	elif(roomType == 4):
		return dotRooms[rng.randi_range(0, dotRooms.size()-1)];
	#Default/failsafe
	else:
		return genericRooms[0];


"""
grabRoom() takes two integers. roomType denotes the array/roomID to index into using a given roomIndex.
This function allows for specific rooms to be loaded when desired
"""
func grabRoom(roomType, roomIndex):
	#Generic Rooms
	if(roomType == 1):
		return genericRooms[roomIndex];
	#Spawn Rooms
	elif(roomType == 2):
		return spawnRooms[roomIndex];
	#Boss Rooms
	elif(roomType == 3):
		return bossRooms[roomIndex];
	#Dot Rooms
	elif(roomType == 4):
		return dotRooms[roomIndex];
	#Default/failsafe
	else:
		return genericRooms[roomIndex];
