extends KinematicBody2D

#const HUD = preload("res://MainHudScene.tscn")

onready var animatedSprite = $Sprite

var speed = 400
var screen_size

var leftMargin = 0
var rightMargin = 0
var topMargin = 0
var bottomMargin = 0

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animatedSprite.play("walkRight")
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animatedSprite.play("walkLeft")
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animatedSprite.play("walkDown")
		
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animatedSprite.play("walkUp")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	else:
		animatedSprite.set_frame(0)
		animatedSprite.stop()
		
	position += velocity * delta
	
	var topX = screen_size.x
	var topY = screen_size.y
	
	position.x = clamp(position.x, leftMargin, (topX - rightMargin))
	position.y = clamp(position.y, topMargin, (topY - bottomMargin))
	

func _ready():
	screen_size = get_viewport_rect().size
	start(Vector2(700,300))

func updateMargin(TOP, BOTTOM, LEFT, RIGHT):
	topMargin = TOP
	bottomMargin = BOTTOM
	leftMargin = LEFT
	rightMargin = RIGHT
	

	
func start(pos):
	position = pos
	show()

	
	
	
	
