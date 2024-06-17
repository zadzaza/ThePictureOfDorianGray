extends Node


signal all_items_done

const NOT_HAS: String = "not_has"
const HAS: String = "has"
const DONE: String = "done"

var is_checking_items = true

func _process(delta):
	if is_checking_items == true:
		var items_done = [
			Dialogic.VAR.bag_state,
			Dialogic.VAR.coat_state,
			Dialogic.VAR.corpse_state,
			Dialogic.VAR.curtain_state,
			Dialogic.VAR.knife_state,
			Dialogic.VAR.lamp_state,
			Dialogic.VAR.rag_state
		]
		
		var is_all_items_done = are_all_items_done(items_done)
		
		if is_all_items_done:
			self.all_items_done.emit()
			is_checking_items = false

func are_all_items_done(items) -> bool:
	for item in items:
		if item != DONE:
			return false
	return true

func set_has(item_name):
	# Тут мы проверяем наличие переменной в Dialogic.VAR перед изменением
	if Dialogic.VAR.has(item_name + "_state"):
		Dialogic.VAR[item_name + "_state"] = HAS

func set_done(item_name):
	# Точно такая же проверка, как в функции pick_item
	if Dialogic.VAR.has(item_name + "_state"):
		Dialogic.VAR[item_name + "_state"] = DONE

func pick_item(item_name, parent_nodes):
	InventoryManager.put_item(item_name)
	InventoryManager.remove_item_node(item_name, parent_nodes.get(item_name))

func done_item(item_name):
	InventoryManager.erase_item(item_name)

func are_all_items_complete(items):
	for key in items.keys():
		if items[key] == false:
			return false
	return true

func start_hint_animation(item_comment: String, parent_position: Vector2):
	var hint_animation = preload("res://UI/HintAnimation/hint_animation.tscn").instantiate()
	add_child(hint_animation)
	hint_animation.start_hint_animation.emit(item_comment, parent_position)
