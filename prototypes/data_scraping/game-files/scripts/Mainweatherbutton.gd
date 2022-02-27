extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")


func _on_Button_pressed():
	$HTTPRequest.request("http://localhost:8080/api/mainweather")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
