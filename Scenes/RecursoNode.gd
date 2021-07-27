extends Sprite
class_name RecursoNode

export(Resource) var recurso = recurso as Recurso
onready var tipo setget , get_tipo


func _ready():
	if recurso:
		texture = recurso.textura


func get_tipo(): # -> Enums.RecursoTipo
	return recurso.tipo


func _on_body_entered(body : Amdre):
	if body:
		#aumentar contador do meu tipo
		Events.emit_signal("recurso_coletado", recurso)
		queue_free()
