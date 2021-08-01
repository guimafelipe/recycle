extends KinematicBody2D
class_name Amdre

export(Resource) var player_state = player_state as PlayerState
export(NodePath) onready var hitbox = get_node(hitbox) as Area2D

export(PackedScene) var bullet

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var to_interact = null

var velocity : Vector2 = Vector2(0,0)

enum Mira{ UP, DOWN, LEFT, RIGHT }
var mira


func _ready():
	mira = Mira.DOWN
	pass


func _physics_process(delta):
	if player_state.game_state == Enums.GameState.FREE:
		move(delta)
	else:
		velocity = Vector2(0,0)


func _input(event : InputEvent):
	if player_state.game_state == Enums.GameState.FREE:
		if event.is_action_pressed("interact"):
			call_deferred("interact")
		if event.is_action_pressed("attack"):
			if $AtaqueCooldown.time_left == 0:
				$AtaqueCooldown.start(player_state.attack_cooldown)
				if player_state.can_melee_attack:
					attack()
				elif player_state.can_ranged_attack:
					shoot()
		if event.is_action_pressed("usar_item"):
			usa_item()


func move(delta : float) -> void:
	var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dy := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var input_vector = Vector2(dx, dy).normalized()
	
	if input_vector != Vector2.ZERO:
		
		if dy != 0:
			if dy > 0:
				mira = Mira.UP
			else:
				mira = Mira.DOWN
		elif dx != 0:
			if dx > 0:
				mira = Mira.RIGHT
			else:
				mira = Mira.LEFT
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * player_state.MAX_SPEED, player_state.ACCELERATION * delta)
	else:
		animationState.travel("Idle")
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
		to_interact.interact(self)


func heal(val : int) -> void:
	player_state.hp += val
	player_state.hp = min(player_state.hp, player_state.max_hp)
	Events.emit_signal("hp_changed")


func take_damage(dmg : int) -> void:
	player_state.hp -= dmg
	player_state.hp = max(0, player_state.hp)
	Events.emit_signal("hp_changed")


func attack():
	var bodies = hitbox.get_overlapping_bodies() as Array
	for body in bodies:
		body = body as PhysicsBody2D
		if body.is_in_group("Enemy"):
			body.take_damage(player_state.dano)


func shoot():
	var b = bullet.instance()
	var direction : Vector2
	if mira == Mira.DOWN:
		direction = Vector2(0, -1)
	elif mira == Mira.UP:
		direction = Vector2(0, 1)
	elif mira == Mira.LEFT:
		direction = Vector2(-1, 0)
	else:
		direction = Vector2(1, 0)
	b.set_params(direction, global_position)
	
	get_tree().root.add_child(b)


func usa_item():
	if player_state.tem_armadilha:
		# spawna armadilha
		pass

