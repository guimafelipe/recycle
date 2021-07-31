extends CanvasLayer

export(Resource) var player_state = player_state as PlayerState
export(NodePath) onready var recursos = get_node(recursos) as HBoxContainer
export(NodePath) onready var armas = get_node(armas) as HBoxContainer
export(NodePath) onready var vida = get_node(vida) as HBoxContainer
export(Texture) var textura_padrao_arma

func _ready():
	Events.connect("recurso_changed", self, "update_ui")
	Events.connect("items_changed", self, "update_ui_armas")
	Events.connect("hp_changed", self, "update_hp")
	Events.connect("can_interact", self, "show_interact_label")
	Events.connect("cannot_interact", self, "hide_interact_label")
	update_ui()
	update_ui_armas()
	update_hp()


func update_ui() -> void:
	for i in range(4): #passando por todos os recursos
		var label = recursos.get_child(2*i + 1) as Label
		if label:
			label.text = str(player_state.recursos[i])


func update_ui_armas():
	(armas.get_child(0) as TextureRect).texture = textura_padrao_arma
	(armas.get_child(1) as TextureRect).texture = textura_padrao_arma
	
	for _item in player_state.items_disponiveis:
		var item = _item as Item
		if player_state.items_disponiveis[item]:
			print(item.nome)
			if item.tipo == Enums.Tipo.ESQUERDA:
				var tex = armas.get_child(0) as TextureRect
				tex.texture = item.textura
			if item.tipo == Enums.Tipo.DIREITA:
				print(item.nome)
				var tex = armas.get_child(1) as TextureRect
				tex.texture = item.textura


func update_hp():
	var barra = vida.get_child(0) as TextureProgress
	var label = barra.get_child(0) as Label
	
	var hp : int = player_state.hp
	
	barra.value = hp
	barra.max_value = player_state.max_hp
	label.text = str(hp)


func show_interact_label():
	$Popup.visible = true

func hide_interact_label():
	$Popup.visible = false
