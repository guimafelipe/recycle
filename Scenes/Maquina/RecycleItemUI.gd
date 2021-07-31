extends MarginContainer
class_name RecycleItemUI


export(NodePath) onready var nome = get_node(nome) as Label 
export(NodePath) onready var icon = get_node(icon) as TextureRect

export(Resource) var item = item as Item
export(Resource) var player_state = player_state as PlayerState
export(Array, Resource) var recursos

func _ready():
	set_focus_mode(FOCUS_ALL)
	if item:
		nome.text = item.nome
		icon.texture = item.textura
		for i in range(4):
			var ui = $Content/Recursos.get_child(i) as HBoxContainer
			var label = ui.get_child(1) as Label
			var icon = ui.get_child(0) as TextureRect
			label.text = str(item.recycle[i])
			icon.texture = recursos[i].textura


func _input(event):
	if player_state.game_state == Enums.GameState.MAQUINA:
		if has_focus() and event.is_action_pressed("ui_accept") and item:
			item.do_recycle(player_state)
			player_state.items_disponiveis[item] = false
			Events.emit_signal("items_changed")
			Events.emit_signal("recurso_changed")


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
