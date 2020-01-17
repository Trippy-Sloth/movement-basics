extends KinematicBody2D

var velocity = Vector2(0, 0)

export (int) var gravity = 9.8
export (int) var floor_speed = 15
export (int) var fly_speed = 50
export (int) var MAX_SPEED_MULT = 10
export (int) var thrust = 80
export (int) var drag = 3


func _physics_process(delta):
	var previousVelocity = Vector2(velocity.x, velocity.y)
	var speed = fly_speed if !is_on_floor() else floor_speed
	var max_speed = MAX_SPEED_MULT * speed
	#speed *= delta
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= (gravity * delta) + speed
	
	var is_moving = previousVelocity != velocity
	
	# Restrict velocity to maximum value
	if velocity.x != 0:
		velocity.x = min(abs(velocity.x), max_speed) * (1 if velocity.x > 0 else -1)
	
	if (!is_on_floor()):
		# Calculate gravity movement
		velocity.y += gravity
	elif(!is_moving):
		# add drag to horizontal movement
		if abs(velocity.x) > 0.1:
			var reduceBy = velocity.x * -1 / drag#
			velocity.x += reduceBy
		else:
			velocity.x = 0
	
	# Apply User movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
	