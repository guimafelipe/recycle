extends Area2D

enum States{
	IDLE,
	SEGUINDO,
	ATACANDO,
	MORTO
}

export(int) var hp = 10
export(int) var max_hp = 20

export(int) var speed = 100
export(int) var ataque_speed = 300

export(int) var range_ataque = 70
export(int) var range_visao = 150

export(float) var cooldown_ataque = 3.0

var alvo : Vector2
var velocity := Vector2(0,0)
var state = States.IDLE
var player : Amdre

func _ready():
	$Visao/CollisionShape2D.shape.radius = range_visao
	$Ataque/CollisionShape2D.shape.radius = range_ataque


func _physics_process(delta : float):
	if state == States.IDLE:
		idle()
	elif state == States.SEGUINDO:
		seguindo(delta)
	elif state == States.ATACANDO:
		atacando(delta)
	elif state == States.MORTO:
		morto()


func idle():
	pass


func seguindo(delta : float):
	velocity = global_position.direction_to(player.global_position).normalized()*speed
	#move_and_slide(velocity)
	translate(velocity*delta)


func atacando(delta : float):
	velocity = global_position.direction_to(alvo)*ataque_speed
	translate(velocity*delta)
	if global_position.distance_to(alvo) < 10:
		state = States.IDLE
		yield(get_tree().create_timer(cooldown_ataque),"timeout")
		if not player:
			state = States.IDLE
		elif $Ataque.overlaps_body(player):
			alvo = player.global_position
			state = States.ATACANDO
		elif $Visao.overlaps_body(player):
			state = States.SEGUINDO


func morto():
	pass


func _on_Visao_body_entered(body : Amdre):
	if not body:
		return
	if state == States.ATACANDO:
		return
	player = body
	state = States.SEGUINDO


func _on_Visao_body_exited(body : Amdre):
	if not body:
		return
	player = null
	if state == States.ATACANDO:
		return
	state = States.IDLE


func _on_Ataque_body_entered(body : Amdre):
	if not body:
		return
	if state == States.ATACANDO:
		return
	if state == States.SEGUINDO:
		alvo = body.global_position
		state = States.ATACANDO


func _on_Ataque_body_exited(body : Amdre):
	if not body:
		return
	if state == States.ATACANDO:
		return
	state = States.SEGUINDO
