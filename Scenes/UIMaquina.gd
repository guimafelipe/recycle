extends MarginContainer

var CraftItemUIScene = preload("res://Scenes/CraftItemUI.tscn")
var RecycleItemUIScene = preload("res://Scenes/RecycleItemUI.tscn")
export(NodePath) onready var craft_lista = get_node(craft_lista) as VBoxContainer
export(NodePath) onready var recycle_lista = get_node(recycle_lista) as VBoxContainer


func add_craft(item : Item):
	var item_ui : CraftItemUI = CraftItemUIScene.instance()
	item_ui.for_item(item)
	craft_lista.add_child(item_ui)
	var craft_parent = craft_lista.get_parent() as ScrollContainer
	craft_parent.scroll_vertical = 0


func add_recycle(item : Item):
	var item_ui : RecycleItemUI = RecycleItemUIScene.instance()
	item_ui.for_item(item)
	recycle_lista.add_child(item_ui)
	var recycle_parent = recycle_lista.get_parent() as ScrollContainer
	recycle_parent.scroll_vertical = 0


func clear_lists():
	for n in craft_lista.get_children():
		craft_lista.remove_child(n)
		n.queue_free()
	
	for n in recycle_lista.get_children():
		recycle_lista.remove_child(n)
		n.queue_free()


func _on_UIMaquina_visibility_changed():
	$TabContainer.current_tab = 0 # reseta pra craft list
	if visible and craft_lista.get_child_count() > 0:
		craft_lista.get_child(0).grab_focus()
		var craft_parent = craft_lista.get_parent() as ScrollContainer
		craft_parent.scroll_vertical = 0
