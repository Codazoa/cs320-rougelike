extends Node

export (PackedScene) var wall;

"""
detectClick is a basic function that checks for a left click input. It returns a true/false boolean. It
was intended for me to test out mouse inputs, as well as practicing function formatting in godot.
"""
func detectClick(event):
		if(event is InputEventMouseButton):
			if((event.button_index == BUTTON_LEFT) and (event.pressed)):
				return true;
		return false;

"""
_input spawns a wall at the cursor position if the left mouse button is clicked
"""
func _input(event):
	if (detectClick(event)):
		gridPlaceTest(event);


func gridPlaceTest(event):
	var desiredWidth = 7;
	var desiredHeight = 5;
	
	for i in range(0, desiredWidth):
		for j in range(0, desiredHeight):
			#Create instance
			var new_wall = wall.instance();
			
			#Grab sprite size
			var wallSprite = new_wall.get_node("StaticBody2D").get_node("SpriteTest");
			var wallWidth = wallSprite.texture.get_width()*wallSprite.scale.x;
			var wallHeight = wallSprite.texture.get_height()*wallSprite.scale.y;
			
			#Modify position
			new_wall.position.x = 0+(i*wallWidth);
			new_wall.position.y = 0+(j*wallHeight);
			add_child(new_wall);
			
			print("x: "+str(i*wallWidth)+", y: "+str(i*wallHeight));
