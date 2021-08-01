extends CanvasLayer

export(Resource) var player_state = player_state as PlayerState
export(NodePath) onready var texto = get_node(texto) as Label
export(NodePath) onready var icon = get_node(icon) as TextureRect


var curr_index : int = 0
var dialogue : Dialogue


func _ready():
	Events.connect("start_dialog", self, "new_dialog")


func new_dialog(_dialogue : Dialogue) -> void:
	if not _dialogue:
		return
	
	dialogue = _dialogue
	
	player_state.game_state = Enums.GameState.DIALOG
	
	curr_index = 0
	$Base.visible = true
	
	if dialogue.textura:
		icon.texture = dialogue.textura
	else:
		icon.texture = null
	
	texto.text = dialogue.falas[0]


func _input(event : InputEvent):
	if player_state.game_state == Enums.GameState.DIALOG and event.is_action_pressed("ui_accept"):
		curr_index += 1
		if curr_index >= dialogue.falas.size():
			player_state.game_state = Enums.GameState.FREE
			$Base.visible = false
			Events.emit_signal("dialog_ended")
			return
		texto.text = dialogue.falas[curr_index]
