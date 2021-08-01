extends Inimigo

enum States{
	ANDANDO,
	ATACANDO,
	VOLTANDO,
	MORTO
}

var state

var indo_pra_direita = true

export(int) var atk_dmg = 13

export(int) var speed = 100
export(int) var ataque_speed = 300
export(int) var volta_speed = 75
export(int) var ataque_range = 40
export(float) var walk_time = 2.5
export(int) var range_visao = 40

onready var original_y = global_position.y

func _ready():
	$RayCast2D.cast_to = Vector2(0, -range_visao)
	state = States.ANDANDO
	$BarraHP.setup_max_val(max_hp)
	connect("hp_update", $BarraHP, "on_update_hp")
	emit_signal("hp_update", hp)


func _physics_process(delta : float):
	player_state = player_state as PlayerState
	if player_state.game_state != Enums.GameState.FREE:
		$WalkTimer.set_paused(true)
		return
	
	$WalkTimer.set_paused(false)
	
	if state == States.ANDANDO:
		anda()
	elif state == States.ATACANDO:
		ataca(delta)
	elif state == States.VOLTANDO:
		volta()
	elif state == States.MORTO:
		morto()


func morto():
	pass


func die():
	state = States.MORTO
	.die()


func anda():
	var direction = Vector2(-1, 0)
	if indo_pra_direita:
		direction = Vector2(1, 0)
	move_and_slide(direction*speed)
	check_raycast_collisions()


func ataca(delta : float):
	var direction = Vector2(0, -1)
	var res := move_and_collide(direction*ataque_speed*delta)
	if res:
		if res.collider is Amdre:
			var body = res.collider as Amdre
			body.take_damage(atk_dmg)
		state = States.VOLTANDO
		return
	
	if global_position.y < original_y - ataque_range:
		state = States.VOLTANDO


func volta():
	var direction = Vector2(0, 1)
	move_and_slide(direction*volta_speed)
	if global_position.y > original_y:
		state = States.ANDANDO
		$WalkTimer.set_paused(false)


func check_raycast_collisions():
	var res = $RayCast2D.get_collider() as Amdre
	if res:
		state = States.ATACANDO
		$WalkTimer.set_paused(true)


func _on_WalkTimer_timeout():
	indo_pra_direita = not indo_pra_direita
