extends Inimigo

enum States {
	IDLE,
	RANGED,
	SEGUINDO,
	ATACANDO,
	BOUNCING,
	RECUPERANDO,
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


var state
var alvo

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
		bouncing(delta)
	elif state == States.RECUPERANDO:
		$RecuperandoTimer.set_paused(false)
	elif state == States.MORTO:
		morto()


func idle():
	pass


func seguindo(delta : float):
	pass


func atacando(delta : float):
	pass


func bouncing(delta : float):
	pass


func ranged():
	pass


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


func _on_RangeSeguir_body_exited(body):
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
