extends Area2D
class_name Armadilha

export(float) var lifetime = 3

func _ready():
	$LifeTime.wait_time = lifetime
	$LifeTime.start()


func die():
	queue_free()


func _on_LifeTime_timeout():
	die()


#func _on_Armadilha_area_entered(coelhinho : Coelhinho):
#	if coelhinho:
#		coelhinho.die()
#		queue_free()
