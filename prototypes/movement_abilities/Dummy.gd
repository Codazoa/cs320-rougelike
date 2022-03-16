extends Node2D

onready var area = $Area2D
onready var healthbar = $HealthDisplay

export var is_player = false

var target = true
export var max_health = 100
var health = 100

export var layer = 0

#take dameage based on attacker damage
func take_damage(damage):
	health = health - damage
	healthbar.update_health(health)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if !is_player:
		area.collision_layer = layer
		area.collision_mask = layer
	else:
		area.collision_layer = 3
		area.collision_mask = 3
#signal when attacking body enters range
func _on_Area2D_body_entered(body):
	print("entered")
	if body.is_in_group("PDamager"):
		take_damage(body.damage)
	if body.is_in_group("Projectile"):
		body.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		if !is_player:
			get_parent().queue_free()
		else:
			get_tree().quit()
