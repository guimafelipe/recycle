extends Inimigo

enum States{
	IDLE,
	SEGUINDO,
	ATACANDO,
	MORTO,
	BOUNCING,
	RECUPERANDO
}

export(int) var atk_dmg = 13


export(int) var speed = 100
export(int) var ataque_speed = 300
export(int) var bouncing_speed = 70

export(int) var range_ataque = 70
export(int) var range_visao = 150

export(float) var cooldown_ataque = 2.0
export(float) var bouncing_duration = 0.25


var alvo : Vector2
var velocity := Vector2(0,0)
var state = States.IDLE
var bouncing_from : Vector2

func _ready():
	$Visao/CollisionShape2D.shape.radius = range_visao
	$Ataque/CollisionShape2D.shape.radius = range_ataque
	$BouncingTimer.wait_time = bouncing_duration
	$BarraHP.setup_max_val(max_hp)
	connect("hp_update", $BarraHP, "on_update_hp")
	emit_signal("hp_update", hp)


func _physics_process(delta : float):
	if player_state.game_state != Enums.GameState.FREE:
		$BouncingTimer.set_paused(true)
		$RecuperandoTimer.set_paused(true)
		return
	
	if state == States.IDLE:
		idle()
	elif state == States.SEGUINDO:
		seguindo(delta)
	elif state == States.ATACANDO:
		atacando(delta)
	elif state == States.BOUNCING:
		$BouncingTimer.set_paused(false)
		bouncing(delta)
	elif state == States.RECUPERANDO:
		$RecuperandoTimer.set_paused(false)
	elif state == States.MORTO:
		morto()


func die():
	state = States.MORTO
	.die()


func idle():
	pass


func seguindo(delta : float):
	velocity = global_position.direction_to(player.global_position).normalized()*speed
	#move_and_slide(velocity)
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


func morto():
	pass


func _on_Visao_body_entered(body : Amdre):
	if not body:
		return
	player = body
	if state == States.IDLE:
		state = States.SEGUINDO


func _on_Visao_body_exited(body : Amdre):
	if not body:
		return
	player = null
	
	if state == States.SEGUINDO:
		state = States.IDLE


func _on_Ataque_body_entered(body : Amdre):
	if not body:
		return
	
	if state == States.SEGUINDO:
		alvo = body.global_position
		state = States.ATACANDO


func _on_Ataque_body_exited(body : Amdre):
	if not body:
		return
	if state == States.IDLE:
		state = States.SEGUINDO


func _on_BouncingTimer_timeout() -> void:
	rescan()


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
	elif $Ataque.overlaps_body(player):
		alvo = player.global_position
		state = States.ATACANDO
	elif $Visao.overlaps_body(player):
		state = States.SEGUINDO
