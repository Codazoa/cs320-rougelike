extends Node

export (PackedScene) var wallScene;

var roomTemplates = []; #Stores data on room template

var rng = RandomNumberGenerator.new();

func _init():
		generateTemplates();

"""
generateTemplates() serves to fill the roomTemplates array with various different rooms.
Said rooms are of different sizes, and of different layouts.
"""
func generateTemplates():
	var roomDesign = [];
	roomDesign.append("#######");
	roomDesign.append("#..#..#");
	roomDesign.append("#.#.#.#");
	roomDesign.append("#..#..#");
	roomDesign.append("#######");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("#######");
	roomDesign.append("#..#..#");
	roomDesign.append("#.###.#");
	roomDesign.append("#..#..#");
	roomDesign.append("#######");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("#######");
	roomDesign.append("#######");
	roomDesign.append("#######");
	roomDesign.append("#######");
	roomDesign.append("#######");
	roomTemplates.append(roomDesign);
	
	roomDesign = [];
	roomDesign.append("###.###");
	roomDesign.append("#.....#");
	roomDesign.append(".......");
	roomDesign.append("#.....#");
	roomDesign.append("###.###");
	roomTemplates.append(roomDesign);	
	roomDesign = [];
	roomDesign.append("###.###");
	roomDesign.append("#..#..#");
	roomDesign.append("..###..");
	roomDesign.append("#..#..#");
	roomDesign.append("###.###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###....###");
	roomDesign.append("#........#");
	roomDesign.append("..........");
	roomDesign.append("#........#");
	roomDesign.append("###....###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###....###");
	roomDesign.append("#...#....#");
	roomDesign.append("..#.#.....");
	roomDesign.append("#.#..#...#");
	roomDesign.append("###....###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###....###");
	roomDesign.append("#.....#..#");
	roomDesign.append("..#.......");
	roomDesign.append("#.....#..#");
	roomDesign.append("###....###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###");
	roomDesign.append("#..");
	roomDesign.append("...");
	roomDesign.append("#.#");
	roomDesign.append("###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###");
	roomDesign.append("###");
	roomDesign.append("###");
	roomDesign.append("###");
	roomDesign.append("###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###");
	roomDesign.append("#.#");
	roomDesign.append("#.#");
	roomDesign.append("#.#");
	roomDesign.append("###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###");
	roomDesign.append("#.#");
	roomDesign.append("###");
	roomDesign.append("#.#");
	roomDesign.append("###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("###");
	roomDesign.append("#..");
	roomDesign.append("...");
	roomDesign.append("...");
	roomDesign.append("...");	
	roomDesign.append("...");	
	roomDesign.append("...");	
	roomDesign.append("...");	
	roomDesign.append("...");	
	roomDesign.append("#.#");
	roomDesign.append("###");
	roomTemplates.append(roomDesign);
	roomDesign = [];
	roomDesign.append("#.#");
	roomDesign.append("...");
	roomDesign.append("#.#");

"""
getTemplate() simply picks a random template from the list of room templates
"""
func getTemplate():
	return rng.randi_range(0, roomTemplates.size()-1);


"""
buildRoom() takes 5 parameters, event, and 4 integers. The first integer templateIndex determines what 
roomTemplate to spawn from the roomTemplates array. The second integer orientation determines whether to 
build the room properly on the x,y axis (0), or build the room on y,x instead (1). The third integer xDirection
determines whether or not to build the room template from left to right (0) or right to left (1).  The third integer 
yDirection determines whether or not to build the room template from up to down (0) or down to up (1).

The room will be constructed based on where the cursor is located. It must be noted that the orientation feature was never
finalized, and as such generates the room in a location impropor to that of the cursor.
"""
func buildRoom(event, templateIndex, orientation, xDirection, yDirection):
	var roomWidth = roomTemplates[templateIndex][0].length();
	var roomHeight = roomTemplates[templateIndex].size();
	var placementMarkerX = 0;
	var placementMarkerY = 0;

	for i in range(roomWidth):
		placementMarkerY = 0;
		for j in range(roomHeight):
			var chosenScene = null;
			var chosenXCalc;
			var chosenYCalc;
			#Determine X orientation
			if(xDirection == 0):
				chosenXCalc = i;
			else:
				chosenXCalc = (roomWidth-1)-i;
				
			#Determine Y orientation
			if(yDirection == 0):
				chosenYCalc = j;
			else:
				chosenYCalc = (roomHeight-1)-j;
			var givenChar = roomTemplates[templateIndex][chosenYCalc][chosenXCalc];
			var displaceX = 0;
			var displaceY = 0;
			
			#Check if givenChar matches any of the below
			match givenChar:
				"#":
					chosenScene = wallScene;
			#Spawn actual object
			if(chosenScene != null):
				var newScene = chosenScene.instance();
				#Grab sprite size
				var newSceneSprite = newScene.get_node("StaticBody2D").get_node("SpriteTest");
				var newSceneWidth = newSceneSprite.texture.get_width()*newSceneSprite.scale.x;
				var newSceneHeight = newSceneSprite.texture.get_height()*newSceneSprite.scale.y;
				
				#Set location and "spawn" it
				if(orientation == 0):
					newScene.position.x = event.position.x + displaceX + ((placementMarkerX)*newSceneWidth);
					newScene.position.y = event.position.y + displaceY + ((j)*newSceneHeight);
				else:
					newScene.position.y = event.position.x + displaceX + ((placementMarkerX)*newSceneWidth);
					newScene.position.x = event.position.y + displaceY + ((j)*newSceneHeight);
				add_child(newScene);
				placementMarkerY = 0;
		placementMarkerX +=1;
"""
DEBUG FUNCTION: detectClick is a basic function that checks for a left click input. It returns a true/false boolean. It
was intended for me to test out mouse inputs, as well as practicing function formatting in godot.
"""
func detectClick(event):
		if(event is InputEventMouseButton):
			if((event.button_index == BUTTON_LEFT) and (event.pressed)):
				return true;
		return false;

"""
DEBUG FUNCTION: _input spawns a wall at the cursor position if the left mouse button is clicked
"""
func _input(event):
	if (detectClick(event)):
		var chosenRoom = getTemplate();
		var chosenOrientation = rng.randi_range(0,1);
		var chosenDirectionX = rng.randi_range(0, 1);
		var chosenDirectionY = rng.randi_range(0, 1);
		buildRoom(event, chosenRoom, chosenOrientation, chosenDirectionX, chosenDirectionY);
