extends Resource
class_name Item

export(Texture) var textura
export(String, MULTILINE) var nome
export(String, MULTILINE) var descricao
export(int) var id

export(Dictionary) var recursos = {
	Enums.RecursoTipo.PAPEL : 0,
	Enums.RecursoTipo.PLASTICO : 0,
	Enums.RecursoTipo.METAL : 0,
	Enums.RecursoTipo.VIDRO : 0
}

export(Dictionary) var recycle = {
	Enums.RecursoTipo.PAPEL : 0,
	Enums.RecursoTipo.PLASTICO : 0,
	Enums.RecursoTipo.METAL : 0,
	Enums.RecursoTipo.VIDRO : 0
}


func craft(player_state : PlayerState) -> void:
	if not can_craft(player_state):
		return
	player_state.recursos[Enums.RecursoTipo.PAPEL] -= recursos[Enums.RecursoTipo.PAPEL]
	player_state.recursos[Enums.RecursoTipo.PLASTICO] -= recursos[Enums.RecursoTipo.PLASTICO]
	player_state.recursos[Enums.RecursoTipo.METAL] -= recursos[Enums.RecursoTipo.METAL]
	player_state.recursos[Enums.RecursoTipo.VIDRO] -= recursos[Enums.RecursoTipo.VIDRO]


func do_recycle(player_state : PlayerState) -> void:
	player_state.recursos[Enums.RecursoTipo.PAPEL] += recycle[Enums.RecursoTipo.PAPEL]
	player_state.recursos[Enums.RecursoTipo.PLASTICO] += recycle[Enums.RecursoTipo.PLASTICO]
	player_state.recursos[Enums.RecursoTipo.METAL] += recycle[Enums.RecursoTipo.METAL]
	player_state.recursos[Enums.RecursoTipo.VIDRO] += recycle[Enums.RecursoTipo.VIDRO]


func can_craft(player_state : PlayerState) -> bool:
	if player_state.recursos[Enums.RecursoTipo.PAPEL] < recursos[Enums.RecursoTipo.PAPEL]:
		return false
	if player_state.recursos[Enums.RecursoTipo.PLASTICO] < recursos[Enums.RecursoTipo.PLASTICO]:
		return false
	if player_state.recursos[Enums.RecursoTipo.METAL] < recursos[Enums.RecursoTipo.METAL]:
		return false
	if player_state.recursos[Enums.RecursoTipo.VIDRO] < recursos[Enums.RecursoTipo.VIDRO]:
		return false
	return true
