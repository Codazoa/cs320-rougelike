extends KinematicBody2D

onready var sprite = $Sprite

export var color = Color(255,255,255)

var trajectory = Vector2()

func recolor(color):
	sprite.modulate = color
	
func shoot(dir, speed):
	var mod_dir = get_angle_to(get_global_mouse_position())
	var angle = Vector2(cos(mod_dir), sin(mod_dir))
	trajectory = angle*speed

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	
	timer.connect("timeout", self, "queue_free")
	timer.set_wait_time(2)
	timer.start()
		
	sprite.rotation = get_angle_to(get_global_mouse_position()) + PI/2
	
func _process(delta):
	move_and_collide(trajectory)
	pass

