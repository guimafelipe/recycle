extends Node2D
class_name RecursoSpawner

var resource = preload("res://Scenes/Recurso/Recurso.tscn")

export(Array, Resource) var recursos
export(Vector2) var spawn_offset = Vector2(50, 50)
export(Array, Vector2) var drop_rates = Array()

func spawn_resource(tipo : int):
	var res = resource.instance()
	res.recurso = recursos[tipo]
	var offset = spawn_offset
	var dx = rand_range(-1, 1)
	var dy = rand_range(-1, 1)
	offset.x *= dx
	offset.y *= dy
	res.global_position = global_position + offset
	get_tree().root.add_child(res)


func drop():
	assert(drop_rates.size() == 4)
	
	for i in range(4): # passa por todos os recursos
		var p = drop_rates[i].x as float
		var qnt = drop_rates[i].y as int
		randomize()
		var t = randf()
		
		if t <= p:
			for j in range(qnt):
				spawn_resource(i)
