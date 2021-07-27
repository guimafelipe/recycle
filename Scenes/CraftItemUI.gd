extends MarginContainer
class_name CraftItemUI


export(NodePath) onready var nome = get_node(nome) as Label 
export(NodePath) onready var icon = get_node(icon) as TextureRect
export(NodePath) onready var description = get_node(description) as Label
export(NodePath) onready var qnt_papel = get_node(qnt_papel) as Label
export(NodePath) onready var qnt_plastico = get_node(qnt_plastico) as Label
export(NodePath) onready var qnt_metal = get_node(qnt_metal) as Label
export(NodePath) onready var qnt_vidro = get_node(qnt_vidro) as Label

var item : Item

func _ready():
	set_focus_mode(FOCUS_ALL)
	if item:
		nome.text = item.nome
		icon.texture = item.textura
		description.text = item.descricao
		qnt_papel.text = str(item.recursos[Enums.RecursoTipo.PAPEL])
		qnt_plastico.text = str(item.recursos[Enums.RecursoTipo.PLASTICO])
		qnt_metal.text = str(item.recursos[Enums.RecursoTipo.METAL])
		qnt_vidro.text = str(item.recursos[Enums.RecursoTipo.VIDRO])


func for_item(_item : Item):
	item = _item


func _on_CraftItemUI_focus_entered():
	modulate = Color(1,0,0)


func _on_CraftItemUI_focus_exited():
	modulate = Color(1,1,1)


func _on_CraftItemUI_mouse_entered():
	modulate = Color(1, 0, 0)


func _on_CraftItemUI_mouse_exited():
	modulate = Color(1,1,1)
