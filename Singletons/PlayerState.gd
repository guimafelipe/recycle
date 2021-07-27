extends Resource
class_name PlayerState

export(Array, Resource) var items_disponiveis  

var recursos := {
		Enums.RecursoTipo.PAPEL: 0,
		Enums.RecursoTipo.PLASTICO: 0,
		Enums.RecursoTipo.METAL: 0,
		Enums.RecursoTipo.VIDRO: 0
	}

var game_state = Enums.GameState.FREE
