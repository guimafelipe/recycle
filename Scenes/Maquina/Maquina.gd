extends Area2D

export(Resource) var player_state = player_state as PlayerState


func _ready():
	update_ui()
	Events.connect("items_changed", self, "update_ui")


func update_ui():
	$UI/UIMaquina.clear_lists()
	for item in player_state.items_disponiveis:
		item = item as Item
		if item:
			if player_state.items_disponiveis[item]:
				$UI/UIMaquina.add_recycle(item)
			else:
				$UI/UIMaquina.add_craft(item)


func _input(event : InputEvent):
	if event.is_action_pressed("interact") and player_state.game_state == Enums.GameState.MAQUINA:
		call_deferred("finish_interact")


func interact() -> void:
	player_state.game_state = Enums.GameState.MAQUINA
	Events.emit_signal("cannot_interact")
	update_ui()
	$UI/UIMaquina.visible = true


func finish_interact() -> void:
	player_state.game_state = Enums.GameState.FREE
	Events.emit_signal("can_interact")
	$UI/UIMaquina.visible = false


func _on_body_entered(player : Amdre):
	if player:
		player.set_interact(self)


func _on_body_exited(player : Amdre):
	if player:
		player.remove_interact()
