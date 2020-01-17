extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var propulsionPoint = Vector2(0.0, $CollisionShape2D.shape.extents.y/2)
	var centerPoint = Vector2($CollisionShape2D.shape.extents.x/2, $CollisionShape2D.shape.extents.y/2)
	
	if Input.is_action_pressed("ui_up"):
		add_central_force(Vector2(0,-10))

	if Input.is_action_pressed("ui_left"):
		add_central_force(Vector2(10, 10))

	if Input.is_action_pressed("ui_right"):
		apply_impulse(centerPoint, Vector2(-10, 0))

func _on_Robot_body_entered(body):
	print("Collision with " + body.get_name())
