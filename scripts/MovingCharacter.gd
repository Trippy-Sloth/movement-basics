extends KinematicBody2D

onready var ANI = $AnimatedSprite
var gravity = 10
var velocity = Vector2()

func _process(delta):
	var state = "idle"
	var is_key_pressed = Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
	
	if is_key_pressed:
		state = "walk"
	
	if ANI.animation != state:
		ANI.play(state)
		
	# Process velocity
	if not is_on_floor():
		velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
