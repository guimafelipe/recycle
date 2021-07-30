extends TabContainer

export(Resource) var player_state = player_state as PlayerState

func _input(event : InputEvent):
	if player_state.game_state == Enums.GameState.MAQUINA:
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			current_tab = (current_tab + 1) % 2
			var curr = get_current_tab_control() as ScrollContainer
			if curr.get_child(0).get_child_count() > 0:
				curr.get_child(0).get_child(0).grab_focus()
