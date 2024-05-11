extends Node

var inventory: Array = ["Лампа", "Труп"]

func put_item(item_name: String):
	if !inventory.has(item_name):
		inventory.append(item_name)
	print(inventory)
	#print("OK")

func get_items():
	return inventory
