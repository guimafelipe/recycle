extends Resource
class_name PlayerState

export(Dictionary) var items_disponiveis

export(Dictionary) var recursos := {
		Enums.RecursoTipo.PAPEL: 0,
		Enums.RecursoTipo.PLASTICO: 0,
		Enums.RecursoTipo.METAL: 0,
		Enums.RecursoTipo.VIDRO: 0
	}

var game_state = Enums.GameState.FREE

export(int) var hp := 80
export(int) var max_hp := 100
export(int) var dano := 20

export(float) var MAX_SPEED = 300
export(float) var ACCELERATION = 400
export(float) var FRICTION = 500

export(bool) var tem_baldinho = false
