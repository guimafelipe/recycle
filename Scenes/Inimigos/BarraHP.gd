extends TextureProgress
class_name BarraHP

func _ready():
	pass


func setup_max_val(val : int):
	max_value = val


func on_update_hp(val : int):
	value = val
