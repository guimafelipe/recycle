extends KinematicBody2D
class_name Amdre

export(float) var MAX_SPEED = 300
export(float) var ACCELERATION = 400
export(float) var FRICTION = 500

var velocity : Vector2 = Vector2(0,0)

func _ready():
	pass

func _physics_process(delta):
	move(delta)


func move(delta : float) -> void:
	var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dy := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var input_vector = Vector2(dx, dy).normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	velocity = move_and_slide(velocity)
