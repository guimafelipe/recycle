extends MarginContainer

var CraftItemUIScene = preload("res://Scenes/CraftItemUI.tscn")

func add_item(item : Item):
	var item_ui : CraftItemUI = CraftItemUIScene.instance()
	item_ui.for_item(item)
	$ItemList/Lista.add_child(item_ui)

func _on_UIMaquina_visibility_changed():
	if visible and $ItemList/Lista.get_child_count() > 0:
		$ItemList/Lista.get_child(0).grab_focus()
