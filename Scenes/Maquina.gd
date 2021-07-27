extends Area2D

export(Resource) var player_state = player_state as PlayerState

func _ready():
	pass

func interact() -> void:
	player_state.game_state = Enums.GameState.MAQUINA
	$UI/UIMaquina.visible = true

func finish_interact() -> void:
	player_state.game_state = Enums.GameState.FREE
	$UI/UIMaquina.visible = false


func _on_body_entered(player : Amdre):
	if player:
		player.set_interact(self)


func _on_body_exited(player : Amdre):
	if player:
		player.remove_interact()
