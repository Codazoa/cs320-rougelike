extends "res://scripts/enemies/EnemyEntity.gd"

var rng = RandomNumberGenerator.new()

#var SlimeBall = preload("res://scenes/player/SlimeBall.tscn")

func _ready():
	rng.randomize()
	
	var angle1 = rng.randi_range(0, 360)
	var angle2 = rng.randi_range(0, 360)
	
	mySprite.scale.x = 1.5
	mySprite.scale.y = 1.5
	mySprite.play("On")
	speed = 500
	
	velocity = Vector2(cos(angle1) * speed, sin(angle2) * speed)
	
	
func _physics_process(delta):
	var collision_info = move_and_collide(velocity*delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
	
	
func _on_AggroRange_body_entered(body):
	currentTarget = body
	#if(currentTarget == get_node(SlimeBall)):
	#	takeDamage()
	
	
func takeDamage():
	health -= 10
	if(health <= 0):
		enemyDeath()
	
	
	
	
	
