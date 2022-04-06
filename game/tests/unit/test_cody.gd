extends "res://addons/gut/test.gd"

const score = preload("res://scripts/rooms/itemScoring.gd")

onready var items = [{"id":1, "score":0 },{"id":2, "score":0 },{"id":3, "score":0 },{"id":4, "score":0 },{"id":5, "score":0 },{"id":6, "score":0 },{"id":7, "score":0 }]


func before_each():
	gut.p("ran setup", 2)

# acceptance test	
func test_getUcb1Scores():
	# initialize the array to have 0 scores
	var arr = [{"id":1},{"id":2},{"id":3}]
	var scores = score.getUcb1Scores(arr)
	assert_eq(scores[0]["score"], 0)
	assert_eq(scores[1]["score"], 0)
	assert_eq(scores[2]["score"], 0)

# acceptance test
func test_updateScore():
	# update score when list is present
	score.updateUCB1Score(items, 1)
	assert_eq(items[0]["score"], 1)

# acceptance test
func test_getNoItems():
	# try to get 0 items
	var itemArr = score.getTopItems(items, 0)
	assert_eq(itemArr.size(), 0)

# acceptance test
func test_getNumItems():
	# get num items within list
	var itemArr = score.getTopItems(items, 3)
	assert_eq(itemArr.size(), 3)

# acceptance test
func test_getMoreItems():
	# get more items than in the list
	var itemArr = score.getTopItems(items, 0)
	assert_eq(itemArr.size(), 7)
	
