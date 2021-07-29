extends Area2D

export(Resource) var player_state = player_state as PlayerState
export(Resource) var dialogue = dialogue as Dialogue

func _ready():
	pass


func _on_TesteDialog_body_entered(body : Amdre):
	Events.emit_signal("start_dialog", dialogue)
	
