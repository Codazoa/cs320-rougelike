extends "res://EnemyEntity.gd"

func _ready():
	mySprite.scale.x = 2
	mySprite.scale.y = 2
	
	speed = 150

func _physics_process(_delta):
	if mySprite.get_animation() == "explode":
		return
		
	updateMovement()

func _on_AggroRange_body_entered(_body):
	mySprite.play("explode")
	
	
	
