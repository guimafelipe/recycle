extends Node2D

export(Resource) var player_state = player_state as PlayerState
export(Resource) var dialog = dialog as Dialogue
export(int) var heal_value = 10

func interact(player : Amdre) -> void:
	if player_state.tem_vara:
		player.heal(heal_value)
	else:
		Events.emit_signal("start_dialog", dialog)


func _on_Area2D_body_entered(player : Amdre):
	if player:
		player.set_interact(self)


func _on_Area2D_body_exited(player : Amdre):
	if player:
		player.remove_interact()
