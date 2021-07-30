extends ItemImplementation
class_name BaldinhoImp

func on_craft(player_state : PlayerState):
	player_state.tem_baldinho = true

func on_recycle(player_state : PlayerState):
	player_state.tem_baldinho = false
