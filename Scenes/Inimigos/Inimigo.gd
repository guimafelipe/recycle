extends KinematicBody2D
class_name Inimigo

export(int) var hp = 10
export(int) var max_hp = 20

export(Resource) var player_state = player_state as PlayerState

signal hp_update(value)

var player : Amdre


func take_damage(dano : int):
	hp -= dano
	hp = max(0, hp)
	emit_signal("hp_update", hp)
	if hp <= 0:
		die()


func die(): # virtual
	var spawner = get_node("RecursoSpawner") as RecursoSpawner
	if spawner:
		spawner.drop()
	queue_free()

