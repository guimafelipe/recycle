extends MarginContainer
class_name RecycleItemUI


export(NodePath) onready var nome = get_node(nome) as Label 
export(NodePath) onready var icon = get_node(icon) as TextureRect
export(NodePath) onready var qnt_papel = get_node(qnt_papel) as Label
export(NodePath) onready var qnt_plastico = get_node(qnt_plastico) as Label
export(NodePath) onready var qnt_metal = get_node(qnt_metal) as Label
export(NodePath) onready var qnt_vidro = get_node(qnt_vidro) as Label

export(Resource) var item = item as Item
export(Resource) var player_state = player_state as PlayerState

func _ready():
	set_focus_mode(FOCUS_ALL)
	if item:
		nome.text = item.nome
		icon.texture = item.textura
		qnt_papel.text = str(item.recycle[Enums.RecursoTipo.PAPEL])
		qnt_plastico.text = str(item.recycle[Enums.RecursoTipo.PLASTICO])
		qnt_metal.text = str(item.recycle[Enums.RecursoTipo.METAL])
		qnt_vidro.text = str(item.recycle[Enums.RecursoTipo.VIDRO])


func _input(event):
	if player_state.game_state == Enums.GameState.MAQUINA:
		if has_focus() and event.is_action_pressed("ui_accept") and item:
			item.do_recycle(player_state)
			player_state.items_disponiveis[item] = false
			Events.emit_signal("items_changed")


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
