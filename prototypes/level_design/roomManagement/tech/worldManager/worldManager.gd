extends Node

var floorplanGeneratorNode;
var roomDatabaseNode;
var roomLayoutNode;
var roomShifterNodes = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Node created: worldManager");
	initialize();

func initialize():
	#Spawn floorplanGenerator
	floorplanGeneratorNode = load("res://tech/floorplanHandling/floorplanGenerator/floorplanGenerator.tscn").instance();
	floorplanGeneratorNode.worldManagerNode = self;
	add_child(floorplanGeneratorNode);
	
	#Spawn roomDatabase
	roomDatabaseNode = load("res://tech/roomDatabase/roomDatabase.tscn").instance();
	roomDatabaseNode.worldManagerNode = self;
	add_child(roomDatabaseNode);
	
	#Spawn roomLayout
	roomLayoutNode = load("res://tech/roomLayout/roomLayout.tscn").instance();
	roomLayoutNode.worldManagerNode = self;
	roomLayoutNode.roomDatabaseNode = roomDatabaseNode;
	add_child(roomLayoutNode);
	
	#Spawn roomShifter
	for i in range(0, 4):
		roomShifterNodes.append(load("res://tech/roomShifter/roomShifter.tscn").instance());
		var sizeX = roomShifterNodes[i].get_node("roomShifter_hitbox").grabSpriteSize(1);
		var sizeY = roomShifterNodes[i].get_node("roomShifter_hitbox").grabSpriteSize(0);
		roomShifterNodes[i].get_node("roomShifter_hitbox").worldManagerNode = self;
		roomShifterNodes[i].get_node("roomShifter_hitbox").shifterType = i;
		add_child(roomShifterNodes[i]);
		match i:
			#Left
			0:
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.x = (sizeX*0)+(sizeX/2);
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.y = (sizeY*4)+(sizeY/2);

			#Right
			1:
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.x = (sizeX*8)+(sizeX/2);
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.y = (sizeY*4)+(sizeY/2);		

			#Up
			2:
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.x = (sizeX*4)+(sizeX/2);
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.y = (sizeY*0)+(sizeY/2);	

		#Down
			3:
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.x = (sizeX*4)+(sizeX/2);
				roomShifterNodes[i].get_node("roomShifter_hitbox").global_position.y = (sizeY*8)+(sizeY/2);		
