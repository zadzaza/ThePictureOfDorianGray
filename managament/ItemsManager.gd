extends Node

const NOT_HAS: String = "not_has"
const HAS: String = "has"
const DONE: String = "done"

func reset_prolog():
	InventoryManager.inventory.clear()
	Dialogic.VAR.have_bird = false

func reset_house():
	InventoryManager.inventory.clear()
	
	Dialogic.VAR.bag_state = NOT_HAS
	Dialogic.VAR.coat_state = NOT_HAS
	Dialogic.VAR.corpse_state = NOT_HAS
	Dialogic.VAR.curtain_state = NOT_HAS
	Dialogic.VAR.knife_state = NOT_HAS
	Dialogic.VAR.lamp_state = NOT_HAS
	Dialogic.VAR.rag_state = NOT_HAS

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
