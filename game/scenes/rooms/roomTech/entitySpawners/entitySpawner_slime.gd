extends Node2D

var spawnTheEnemyScript = preload("res://scripts/enemies/SpawnEnemy.gd");

var Slime = preload("res://scenes/enemies/the_Slime.tscn");

#All of the following code was written by Dylan, but needed to be refactored by Sydney to make it compatible
"""
The following function was written by Dylan, however it needed to be slightly refactored to work properly with my (Sydney's) code.
This function simply spawns the desired enemy at the given coordinates.
"""
func spawnTheEnemy(specificEnemy, positionX, positionY):
	if(specificEnemy == "slime"):
		var slime = Slime.instance();
		add_child(slime);
		slime.global_position = Vector2(positionX, positionY);

#All of the following code was written by Sydney Burgess
func _ready():
	scale.x = 2;
	scale.y = 2;
	spawnTheEnemy("slime", self.global_position.x+32, self.global_position.y+32);
	$Sprite.hide();
	
