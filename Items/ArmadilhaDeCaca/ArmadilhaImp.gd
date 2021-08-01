extends ItemImplementation
class_name ArmadilhaImp

func on_craft(player_state : PlayerState):
	player_state.tem_armadilha = true


func on_recycle(player_state : PlayerState):
	player_state.tem_armadilha = false
