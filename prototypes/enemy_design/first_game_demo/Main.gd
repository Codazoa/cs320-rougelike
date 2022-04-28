extends Node

#########################################################################################################
#													#
#	The following was written by Dylan Strong							#
#													#
#########################################################################################################

"""
	Goal: The goal of the main.gd demo script was to create a first attempt at Godot game, directly
	referencing a tutorial used on their documentation website. The base functionality was having operations
	for a new game, a game over, some basic timers as well as creaing the new game on start up

"""

export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	
	add_child(mob)
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	mob.position = $MobPath/MobSpawnLocation.position
	
	mob.linear_velocity = Vector2(mob.max_speed, 0)
	
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	
