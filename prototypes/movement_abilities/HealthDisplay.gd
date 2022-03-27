extends Node2D

onready var healthbar = $HealthBar

export var full_color = Color(1,1,1)
export var half_color = Color(.5,.5,.5)
export var low_color = Color(.25,.25,.25)

export var size = 1

var value = 0
var max_value = 0
var min_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
#	if get_parent().is_player:
##		global_position.x = 100
##		global_position.y = 100
##		size = 4
	healthbar.modulate = full_color
	if get_parent() and get_parent().get("max_health"):
		max_value = get_parent().max_health

#Updates the healthbar visual
func update_health(health):
	if health < 0 or health > max_value:
		print("invalid health input")
		return null
		
	var ratio = float(size)*(float(health) / float(max_value))
	healthbar.scale.x = ratio
	if ratio < 0.75:
		healthbar.modulate = half_color
	if ratio < 0.35:
		healthbar.modulate = low_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
