extends KinematicBody2D
class_name Amdre

export(Resource) var player_state = player_state as PlayerState

var to_interact = null

var velocity : Vector2 = Vector2(0,0)

func _ready():
	pass


func _physics_process(delta):
	if player_state.game_state == Enums.GameState.FREE:
		move(delta)
	else:
		velocity = Vector2(0,0)


func _input(event : InputEvent):
	if event.is_action_pressed("interact"):
		if player_state.game_state == Enums.GameState.FREE:
			call_deferred("interact")


func move(delta : float) -> void:
	var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dy := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var input_vector = Vector2(dx, dy).normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * player_state.MAX_SPEED, player_state.ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, player_state.FRICTION*delta)
	
	velocity = move_and_slide(velocity)


func set_interact(obj):
	if obj.has_method("interact"):
		to_interact = obj
		Events.emit_signal("can_interact")


func remove_interact():
	to_interact = null
	Events.emit_signal("cannot_interact")


func interact():
	if to_interact:
		to_interact.interact()


func heal(val : int) -> void:
	player_state.hp += val
	player_state.hp = min(player_state.hp, player_state.max_hp)
	Events.emit_signal("hp_changed")


func take_damage(dmg : int) -> void:
	player_state.hp -= dmg
	player_state.hp = max(0, player_state.hp)
	Events.emit_signal("hp_changed")
