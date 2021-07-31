extends Area2D

enum States{
	NATOCA,
	VIVO,
	MORTO
}

export(float) var spawn_time = 1
export(float) var alive_time = 2

var state

func _ready():
	$SpawnTimer.wait_time = spawn_time
	$AliveTimer.wait_time = alive_time
	state = States.NATOCA
	monitoring = true
	$CollisionShape2D.disabled = true
	execute()


func die():
	state = States.MORTO
	$RecursoSpawner.drop()
	queue_free()

func execute():
	$SpawnTimer.start()
	yield($SpawnTimer, "timeout")
	state = States.VIVO
	$CollisionShape2D.disabled = false
	$Coelho.visible = true
	$AliveTimer.start()
	yield($AliveTimer, "timeout")
	state = States.NATOCA
	$CollisionShape2D.disabled = true
	$Coelho.visible = false
	$SpawnTimer.start()
	yield($SpawnTimer, "timeout")
	queue_free()


func _on_Coelhinho_area_entered(area : Armadilha):
	if area:
		die()
