extends CanvasLayer

func _ready():
	$dotHTMLReq.connect("request_completed", self, "_on_request_completed")

func _on_Button_pressed():
	$dotHTMLReq.request("http://localhost:8080/api/dotrgb")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
