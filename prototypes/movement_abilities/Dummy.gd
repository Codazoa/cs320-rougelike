extends Node2D

onready var healthbar = $HealthDisplay

var target = true
export var max_health = 100
var health = 100

func take_damage(damage):
	health = health - damage
	healthbar.update_health(health)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	print("entered")
	take_damage(body.damage)
	if body.is_in_group("Projectile"):
		body.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if health <= 0:
		queue_free()
