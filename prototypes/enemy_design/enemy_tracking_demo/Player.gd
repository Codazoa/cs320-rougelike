extends KinematicBody2D

signal found
signal hidden

onready var animatedSprite = $AnimatedSprite

var speed = 250
var screen_size

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animatedSprite.play("rightWalk")
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animatedSprite.play("leftWalk")
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animatedSprite.play("downWalk")
		
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animatedSprite.play("upWalk")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	else:
		animatedSprite.set_frame(0)
		animatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func _ready():
	screen_size = get_viewport_rect().size

func _on_AgroRange_body_entered(body):
	emit_signal("found")

func _on_AgroRange_body_exited(body):
	emit_signal("hidden")
