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

var factory = ItemFactory.new()

onready var itemList = [factory.create(), factory.create(), 
	factory.create(), factory.create(), factory.create()]

onready var leftSpawn = $left/leftSprite
onready var rightSpawn = $right/rightSprite

var left
var right

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("http://game.api.hippyhouse.net:22800/api/dotrgb")
	update_color()
	var newScores = getUcb1Scores()
	spawn_items(newScores[0], newScores[1])
	pass

func _on_Timer_timeout():
	$HTTPRequest.request("http://game.api.hippyhouse.net:22800/api/dotrgb")
	
func update_color():
	$Sprite.self_modulate = Color8(color_data["r"], color_data["g"], color_data["b"])
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	color_data = json.result
	update_color()
	
func spawn_items(leftItem, rightItem):
	""" Spawns the given items in the left and right spawning spaces
		takes two items
		returns nothing"""
	left = leftItem
	right = rightItem
	left.time = OS.get_unix_time()
	right.time = OS.get_unix_time()
	print("Spawning IDs: %d and %d" % [left.id, right.id])
	leftSpawn.texture = load(left.spriteLoc)
	rightSpawn.texture = load(right.spriteLoc)

# itemscoring code below
func ucb1(item):
	""" Calculates the UCB1 score of the given item
		takes an item object
		returns the UCB1 score """
	var alpha = 0.5
	var clicks = item.clicks
	var shown = item.shown
	var time = OS.get_unix_time() - item.time 
	
	print("ItemID: %d\tClicks: %d\tShown: %d\tTime: %d" % [item.id , clicks , shown , time])
	return (((clicks)/(shown))+(alpha * ((2 * log(time))/(shown))))
	
func getUcb1Scores():
	""" Retrieves the first two items from the item list
		takes no arguments
		returns the first two item in the sorted list"""
	itemList.sort_custom(MyCustomSorter, "sort_scores")
	for item in itemList:
		print(str(item.id) + " SCORE: " + str(item.score))
	return [itemList[0], itemList[1]]
	
func updateUCB1Score():
	"""Updates the UCB1 scores of all items to spawn
	   takes no argumens
	   returns nothing """
	for item in itemList:
		var itemID = item.id
		var newScore = ucb1(item)
		item.score = newScore
		

class MyCustomSorter:
	""" This class is for sorting the list of items by their UBC1 score"""
	static func sort_scores(a, b):
		if a.score > b.score:
			return true
		return false
		

class MerchantItem:
	""" Class to store item information 
		Used by the factory class to create proper IDs""" 
	var clicks = 0
	var shown = 1
	var score = 0
	var time = OS.get_unix_time()
	var id
	var spriteLoc = "res://data/item%d.png" % id
	var sceneLoc = "res://data/Item%d.tscn" % id
	var scene = load(sceneLoc)
	
	func _init(id):
		self.id = id
	
class ItemFactory:
	""" Factory to create items with proper formating"""
	var numCreated = 0
	
	func create():
		self.numCreated = self.numCreated + 1
		return MerchantItem.new(self.numCreated)
	
	
func _on_leftButton_pressed():
	""" Checks for button input events
		updates the UCB1 scores, destroys the spawned items, gets new items to spawn """
	left.clicks += 1
	
	left.shown += 1
	right.shown += 1
	
	updateUCB1Score()
	leftSpawn.texture = null
	rightSpawn.texture = null
	var newScores = getUcb1Scores()
	spawn_items(newScores[0], newScores[1])

func _on_rightButton_pressed():
	""" Checks for button input events
		updates the UCB1 scores, destroys the spawned items, gets new items to spawn """
	right.clicks += 1
	
	left.shown += 1
	right.shown += 1
	
	updateUCB1Score()
	leftSpawn.texture = null
	rightSpawn.texture = null
	var newScores = getUcb1Scores()
	spawn_items(newScores[0], newScores[1])
