extends Node

onready var enemyEntity = get_tree().get_child("enemyCreator")

var rng = RandomNumberGenerator.new()

func _ready():
	pass # Replace with function body.


func randomizeAttackType():
	var possibleOptions = rng.randi_range(0,2)
	if possibleOptions == 0:
		enemyEntity.enemy.mySprite.play("AttackOne")
	if possibleOptions == 1:
		enemyEntity.enemy.mySprite.play("AttackTwo")
	if possibleOptions == 2:
		enemyEntity.enemy.mySprite.play("AttackThree")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
