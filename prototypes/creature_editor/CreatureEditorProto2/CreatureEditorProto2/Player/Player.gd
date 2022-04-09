extends KinematicBody2D


export (int) var speed = 200
var velocity = Vector2()


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


func _physics_process(delta):
	get_input()
	# Prevent the player from moving while editorGUI open
	if get_tree().paused != true:
		velocity = move_and_slide(velocity)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	velocity = velocity.normalized() * speed

# !! Check whether being paused is an issue if still have problems
func on_part_received(part_name, position):
	print("player function")
	
	# !! TO-DO: This is being wacky for some reason
	# Might be what position we are grabbing in DraggablePart
	# Get proper position of part on player
	var height_extent = $CollisionShape2D.shape.extents.y + 5
	var width_extent = $CollisionShape2D.shape.extents.x + 5
	var center_of_screen = get_viewport_rect().size / 2
	var position_on_player = position - center_of_screen
	if abs(position_on_player.x) > (width_extent):
		if position_on_player.x < 0:
			position_on_player.x = -width_extent
		else:
			position_on_player.x = width_extent
	if abs(position_on_player.y) > (height_extent):
		if position_on_player.y < 0:
			position_on_player.y = -height_extent
		else:
			position_on_player.y = height_extent
	
	var part_sprite = Sprite.new()
	part_sprite.texture = (PartDatabase.get_part(part_name)).texture
	#var part_instance = part_sprite.instance()
	part_sprite.name = part_name
	part_sprite.position.x = position_on_player.x
	part_sprite.position.y = position_on_player.y
	part_sprite.scale = part_sprite.scale / 4
	add_child(part_sprite)
