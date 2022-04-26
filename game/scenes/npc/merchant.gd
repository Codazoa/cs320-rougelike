extends Node2D

var color_data = {"r": 255, "g": 255, "b": 255}
var scores = 	[{"id": 0, "name": "Item1", "score": 1 },
				{"id": 1, "name": "Item2", "score": 1 },
				{"id": 2, "name": "Item3", "score": 1 },
				{"id": 3, "name": "Item4", "score": 5 },
				{"id": 4, "name": "Item5", "score": 1 }]

# loading in item scenes to spawn them
onready var item1 = preload("res://data/Item1.tscn")
onready var item2 = preload("res://data/Item2.tscn")
onready var item3 = preload("res://data/Item3.tscn")
onready var item4 = preload("res://data/Item4.tscn")
onready var item5 = preload("res://data/Item5.tscn")

onready var itemList = [item1, item2, item3, item4, item5]

onready var leftSpawn = $left
onready var rightSpawn = $right

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in itemList:
		item.instance().time = OS.get_unix_time()
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("http://game.api.hippyhouse.net:22800/api/dotrgb")
	update_color()
	var newScores = getUcb1Scores()
	spawn_items(itemList[newScores[0].id], itemList[newScores[1].id])
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		updateUCB1Score()
		leftSpawn.get_child(0).queue_free()
		rightSpawn.get_child(0).queue_free()
		var newScores = getUcb1Scores()
		spawn_items(itemList[newScores[0].id], itemList[newScores[1].id])

func _on_Timer_timeout():
	$HTTPRequest.request("http://game.api.hippyhouse.net:22800/api/dotrgb")
	
func update_color():
	$Sprite.self_modulate = Color8(color_data["r"], color_data["g"], color_data["b"])
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	color_data = json.result
	update_color()
	
func spawn_items(leftItem, rightItem): # spawn in left and right spots
	print("spawning")
	var left = leftItem.instance()
	var right = rightItem.instance()
	print(left.name, right.name)
	leftSpawn.add_child(left)
	rightSpawn.add_child(right)

# itemscoring code below
func ucb1(item):
	var alpha = 0.5
	var clicks = item.clicks
	var shown = item.shown
	var time = OS.get_unix_time() - item.time 
	
	print("clicks: " + str(clicks))
	print("shown: " + str(shown))
	print("time: " + str(time))
	return (((clicks)/(shown))+(alpha * ((2 * log(time))/(shown))))
	
func getUcb1Scores():
	scores.sort_custom(MyCustomSorter, "sort_scores")
	print(scores)
	return [scores[0], scores[1]]
	
func updateUCB1Score():
	for item in itemList:
		item = item.instance()
		var itName = item.name
		var newScore = ucb1(item)
		for score in scores:
			if score.name == itName:
				score.score = newScore

class MyCustomSorter:
	static func sort_scores(a, b):
		if a.score > b.score:
			return true
		return false

		
	
