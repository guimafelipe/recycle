extends KinematicBody2D
class_name Bullet


export(int) var speed = 140
export(float) var lifetime = 15
export(int) var damage = 14

var alvo : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO



func set_alvo(_alvo : Vector2, _origin : Vector2) -> void:
	alvo = _alvo
	global_position = _origin
	direction = (alvo - global_position).normalized()


func _ready():
	$LifeTime.start()


func _physics_process(delta) -> void:
	var res = move_and_collide(direction*speed*delta) as KinematicCollision2D
	if res:
		if res.collider is Amdre:
			var player = res.collider as Amdre
			player.take_damage(damage)
		queue_free()


func _on_LifeTime_timeout():
	queue_free()
