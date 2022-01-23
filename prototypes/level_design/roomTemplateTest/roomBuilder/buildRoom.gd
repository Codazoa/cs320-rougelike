extends Node

export (PackedScene) var wallScene;

var roomTemplates = []; #Stores data on room template

var rng = RandomNumberGenerator.new();

func getTemplate():
	var roomDesign = [];
	roomDesign.append("#######");
	roomDesign.append("#..#..#");
	roomDesign.append("#.#.#.#");
	roomDesign.append("#..#..#");
	roomDesign.append("#######");
	roomTemplates.append(roomDesign);

func buildRoom(event, templateIndex):
	var roomWidth = roomTemplates[templateIndex][0].length();
	var roomHeight = roomTemplates[templateIndex].size();
	
	for i in range(roomWidth):
		for j in range(roomHeight):
			var chosenScene = null;
			var givenChar = roomTemplates[templateIndex][j][i];
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
				newScene.position.x= event.position.x + displaceX + ((i)*newSceneWidth);
				newScene.position.y = event.position.y + displaceY + ((j)*newSceneHeight);
				add_child(newScene);


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
		getTemplate();
		buildRoom(event, 0);
