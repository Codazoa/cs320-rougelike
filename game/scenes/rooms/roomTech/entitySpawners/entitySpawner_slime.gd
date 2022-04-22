extends Node2D

var spawnTheEnemyScript = preload("res://scripts/enemies/SpawnEnemy.gd");

var Slime = preload("res://scenes/enemies/the_Slime.tscn");

func spawnTheEnemy(specificEnemy, positionX, positionY):
	if(specificEnemy == "slime"):
		var slime = Slime.instance();
		add_child(slime);
		slime.global_position = Vector2(positionX, positionY);

func _ready():
	scale.x = 2;
	scale.y = 2;
	spawnTheEnemy("slime", self.global_position.x+32, self.global_position.y+32);
	$Sprite.hide();
	
