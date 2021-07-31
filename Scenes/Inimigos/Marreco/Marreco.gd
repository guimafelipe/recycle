extends KinematicBody2D

enum States{
	IDLE,
	RANGED,
	MELEE,
	MORTO
	ATACANDO,
	BOUNCING,
	RECUPERANDO
}

export(int) var hp = 10
export(int) var max_hp = 20
export(int) var atk_dmg = 13

export(int) var speed = 100
export(int) var ataque_speed = 300
export(int) var bouncing_speed = 70

export(int) var range_ataque = 70

export(float) var cooldown_ataque = 2.0
export(float) var bouncing_duration = 0.25

export(int) var range_tiro = 150
export(float) var cooldown_tiro = 1.0
export(int) var dano_tiro = 5

export(PackedScene) var bullet_scene
export(Resource) var player_state = player_state as PlayerState

signal hp_update(value)

var alvo : Vector2
var velocity := Vector2(0,0)
var state = States.IDLE
var player : Amdre
var bouncing_from : Vector2


func _ready():
	$Ranged/CollisionShape2D.shape.radius = range_tiro
	$Melee/CollisionShape2D.shape.radius = range_ataque
	$BouncingTimer.wait_time = bouncing_duration
	$TiroCooldown.wait_time = cooldown_tiro
	$BarraHP.setup_max_val(max_hp)
	connect("hp_update", $BarraHP, "on_update_hp")
	emit_signal("hp_update", hp)

func _physics_process(delta : float):
	if player_state.game_state != Enums.GameState.FREE:
		$BouncingTimer.set_paused(true)
		$RecuperandoTimer.set_paused(true)
		$TiroCooldown.set_paused(true)
		return
	
	if state == States.IDLE:
		idle()
	elif state == States.RANGED:
		$TiroCooldown.set_paused(false)
		ranged()
	elif state == States.ATACANDO:
		atacando(delta)
	elif state == States.BOUNCING:
		$BouncingTimer.set_paused(false)
		bouncing(delta)
	elif state == States.RECUPERANDO:
		$RecuperandoTimer.set_paused(false)
	elif state == States.MORTO:
		morto()


func take_damage(dano : int):
	hp -= dano
	hp = max(0, hp)
	emit_signal("hp_update", hp)
	if hp <= 0:
		die()


func die():
	state = States.MORTO


func idle() -> void:
	pass


func ranged() -> void:
	if $TiroCooldown.time_left == 0:
		atira()
		$TiroCooldown.start()


func atira() -> void:
	var target = player.global_position
	var bullet = bullet_scene.instance() as Bullet
	bullet.set_alvo(target, global_position)
	get_tree().root.add_child(bullet)


func atacando(delta : float) -> void:
	velocity = global_position.direction_to(alvo)*ataque_speed
	var res := move_and_collide(velocity*delta)

	if res:
		if res.collider is Amdre:
			var body = res.collider as Amdre
			body.take_damage(atk_dmg)
			bouncing_from = res.position
			state = States.BOUNCING
			$BouncingTimer.start()
			return
	
	if global_position.distance_to(alvo) < 10:
		rescan()


func bouncing(delta : float):
	velocity = -global_position.direction_to(bouncing_from)*bouncing_speed
	move_and_slide(velocity)


func morto():
	pass


func rescan() -> void:
	print(state)
	if state == States.MORTO:
		return
	
	state = States.RECUPERANDO
	$RecuperandoTimer.start(cooldown_ataque)
	yield($RecuperandoTimer, "timeout")
	
	if state == States.MORTO:
		return
	
	if not player:
		state = States.IDLE
	elif $Melee.overlaps_body(player):
		alvo = player.global_position
		state = States.ATACANDO
	elif $Ranged.overlaps_body(player):
		state = States.RANGED


func _on_Ranged_body_entered(body : Amdre):
	if not body:
		return
	player = body
	if state == States.IDLE:
		state = States.RANGED


func _on_Ranged_body_exited(body : Amdre):
	if not body:
		return
	player = null
	if state == States.RANGED:
		state = States.IDLE


func _on_Melee_body_entered(body : Amdre):
	if not body:
		return
	if state == States.RANGED:
		alvo = body.global_position
		state = States.ATACANDO


func _on_Melee_body_exited(body : Amdre):
	if not body:
		return
	if state == States.IDLE:
		state = States.RANGED


func _on_BouncingTimer_timeout():
	rescan()
