extends KinematicBody2D
class_name AmdreBullet

export(Resource) var player_state = player_state as PlayerState

export(int) var lifetime = 15

var direction : Vector2

func set_params(_direction : Vector2, _origin : Vector2):
	direction = _direction
	global_position = _origin


func _ready():
	$LifeTime.wait_time = lifetime
	$LifeTime.start()


func _physics_process(delta) -> void:
	var res = move_and_collide(direction*player_state.bullet_speed*delta) as KinematicCollision2D
	if res:
		if res.collider is Inimigo:
			var inimigo = res.collider as Inimigo
			inimigo.take_damage(player_state.dano)
		queue_free()


func _on_LifeTime_timeout():
	queue_free()
