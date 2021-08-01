extends Inimigo

enum States {
	IDLE,
	RANGED,
	SEGUINDO,
	ATACANDO,
	BOUNCING,
	RECUPERANDO,
	MORTO
}

export(int) var atk_dmg = 45
export(int) var dano_tiro = 40
export(float) var cooldown_tiro = 3.0

export(int) var follow_speed = 400
export(int) var ataque_speed = 800
export(int) var bouncing_speed = 200

export(int) var range_ataque = 600
export(int) var range_seguir = 1000
export(int) var range_tiro = 2000

export(float) var cooldown_ataque = 2.0
export(float) var bouncing_duration = 2.0

export(PackedScene) var bullet_scene

export(Resource) var dialogo = dialogo as Dialogue

var bouncing_from : Vector2
var velocity := Vector2.ZERO
var state
var alvo : Vector2

func _ready():
	$RangeMelee/CollisionShape2D.shape.radius = range_ataque
	$RangeSeguir/CollisionShape2D.shape.radius = range_seguir
	$RangeAtirar/CollisionShape2D.shape.radius = range_tiro
	state = States.IDLE


func _physics_process(delta : float):
	if player_state.game_state != Enums.GameState.FREE:
		$BouncingTimer.set_paused(true)
		$RecuperandoTimer.set_paused(true)
		return
	
	if state == States.IDLE:
		idle()
	elif state == States.RANGED:
		$TiroCooldown.set_paused(false)
		ranged()
	elif state == States.SEGUINDO:
		seguindo(delta)
	elif state == States.ATACANDO:
		atacando(delta)
	elif state == States.BOUNCING:
		$BouncingTimer.set_paused(false)
	elif state == States.RECUPERANDO:
		$RecuperandoTimer.set_paused(false)
	elif state == States.MORTO:
		morto()


func idle():
	pass


func seguindo(delta : float):
	velocity = global_position.direction_to(player.global_position).normalized()*follow_speed
	move_and_slide(velocity)


func atacando(delta : float):
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


func ranged():
	if $TiroCooldown.time_left == 0:
		atira()
		$TiroCooldown.start(cooldown_tiro)


func atira() -> void:
	var target = player.global_position
	var bullet = bullet_scene.instance() as BossBullet
	bullet.set_alvo(target, global_position)
	get_tree().root.add_child(bullet)


func morto():
	pass


func _on_RangeMelee_body_entered(body : Amdre):
	if not body:
		return
	if state == States.SEGUINDO:
		alvo = body.global_position
		state = States.ATACANDO


func _on_RangeMelee_body_exited(body : Amdre):
	if not body:
		return
	if state == States.IDLE:
		state = States.SEGUINDO


func _on_RangeSeguir_body_entered(body : Amdre):
	if not body:
		return
	player = body
	if state == States.RANGED:
		state = States.SEGUINDO


func _on_RangeSeguir_body_exited(body : Amdre):
	if not body:
		return
	if state == States.RANGED:
		state = States.IDLE


func _on_RangeAtirar_body_entered(body : Amdre):
	if not body:
		return
	player = body
	if state == States.IDLE:
		state = States.RANGED


func _on_RangeAtirar_body_exited(body : Amdre):
	if not body:
		return
	player = null
	if state == States.RANGED:
		state = States.IDLE


func rescan() -> void:
	if state == States.MORTO:
		return
	
	state = States.RECUPERANDO
	$RecuperandoTimer.start(cooldown_ataque)
	yield($RecuperandoTimer, "timeout")
	
	if state == States.MORTO:
		return
	
	if not player:
		state = States.IDLE
	elif $RangeMelee.overlaps_body(player):
		alvo = player.global_position
		state = States.ATACANDO
	elif $RangeSeguir.overlaps_body(player):
		state = States.SEGUINDO
	elif $RangeAtirar.overlaps_body(player):
		state = States.RANGED


func die():
	Events.emit_signal("start_dialog", dialogo)

func _on_BouncingTimer_timeout():
	rescan()
