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
