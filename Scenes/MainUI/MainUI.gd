extends CanvasLayer

export(Resource) var player_state = player_state as PlayerState
export(NodePath) onready var recursos = get_node(recursos) as HBoxContainer
export(NodePath) onready var armas = get_node(armas) as HBoxContainer
export(NodePath) onready var vida = get_node(vida) as HBoxContainer


func _ready():
	Events.connect("recurso_changed", self, "update_ui")
	Events.connect("items_changed", self, "update_ui")
	Events.connect("hp_changed", self, "update_hp")
	update_ui()
	update_hp()


func update_ui() -> void:
	for i in range(4): #passando por todos os recursos
		var label = recursos.get_child(2*i + 1) as Label
		if label:
			label.text = str(player_state.recursos[i])
	
	# atualizar armas


func update_hp():
	var barra = vida.get_child(0) as TextureProgress
	var label = barra.get_child(0) as Label
	
	var hp : int = player_state.hp
	
	barra.value = hp
	barra.max_value = player_state.max_hp
	label.text = str(hp)
