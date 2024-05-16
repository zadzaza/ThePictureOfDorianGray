extends Node

var inventory: Array

func put_item(item_name: String):
	if !inventory.has(item_name):
		inventory.append(item_name)
		print("Инвентарь: ", inventory)

func erase_item(item_name: String):
	if inventory.has(item_name):
		inventory.erase(item_name)

func remove_item_node(item_name: String, node_to_remove):
	if node_to_remove != null:
		node_to_remove.queue_free()

func get_items():
	return inventory
