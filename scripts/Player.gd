extends KinematicBody2D

var velocity = Vector2(0, 0)

# Movement variables
export (int) var gravity = 9.8
export (int) var floor_speed = 15
export (int) var fly_speed = 50
export (int) var MAX_SPEED_MULT = 10
export (int) var thrust = 80
export (int) var drag = 3

# Fuel variables
export (int) var MAX_FUEL = 100
export (int) var fuel_charge_speed = 10
var fuel = 10

# Animation variables
onready var animation
var default_flip_h = false
var state = "default"

func _ready():
	animation = $Animation


func _input(event):
	if event is InputEventKey and event.is_pressed() and !is_on_floor():
		consumeFuel(1)

func consumeFuel(quantity):
	if fuel > 0:
		fuel -= quantity

func refuel(quantity):
	if fuel < MAX_FUEL:
		fuel += quantity
		
func can_fly():
	"""Determines of the object can fly or not."""
	return fuel > 0 

func _movement(delta):
	var speed = fly_speed if not is_on_floor() else floor_speed
	var max_speed = MAX_SPEED_MULT * speed
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	
	# Restrict velocity to maximum value
	if velocity.x != 0:
		velocity.x = min(abs(velocity.x), max_speed) * (1 if velocity.x > 0 else -1)

	# If Player can fly then vertical velocities are allowed.
	if can_fly():
		# When user presses up it nulls the gravity force
		# and adds the rocket thrust force.
		if Input.is_action_pressed("ui_up"):
			velocity.y -= (gravity * delta) + speed
		
		if Input.is_action_pressed("ui_down"):
			velocity.y += speed
	
	if not is_on_floor():
		# Calculate gravity movement
		velocity.y += gravity		
	else:
		# add drag to horizontal movement
		if abs(velocity.x) > 0.1:
			var reduceBy = -velocity.x / drag
			velocity.x += reduceBy
		else:
			velocity.x = 0
	
	# Apply User movement
	velocity = move_and_slide(velocity, Vector2.UP)	
	

func _animation_control():
	"""Controls the animation logic according to player's input and object's velocity."""
	if Input.is_action_pressed("ui_left"):
		default_flip_h = true
	if Input.is_action_pressed("ui_right"):
		default_flip_h = false
		
	animation.flip_h = true if velocity.x < 0 else default_flip_h
	
	if is_on_floor():
		state = "default"
	else:
		# If is grounded we check if user is moving. If so then we set 
		# the animation to play accordingly.
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			state = "walk"
		else:
			state = "idle"
	
	if animation.animation != state:
		animation.play(state)	


func _physics_process(delta):
	_movement(delta)
	_animation_control()


func _process(delta):
	if is_on_floor():
		refuel(fuel_charge_speed * delta)
