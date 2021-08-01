extends "res://Items/ItemImplementation.gd"
class_name EspadaImp

func on_craft(player_state : PlayerState):
	player_state.tem_direita = true
	player_state.can_melee_attack = true

func on_recycle(player_state : PlayerState):
	player_state.tem_direita = false
	player_state.can_melee_attack = false
