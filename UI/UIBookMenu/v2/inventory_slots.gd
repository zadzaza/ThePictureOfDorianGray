extends GridContainer

@onready var lamp_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/lamp_icon.png")
@onready var corpse_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/corpse_icon.png")

@onready var slot_number = 1
@onready var slot_name = "Slot" + str(slot_number)
@onready var current_slot = get_node_or_null(slot_name)

@onready var item_icons = {
	"Лампа": lamp_icon,
	"Труп": corpse_icon
}

func _ready():
	refresh_slots()

func refresh_slots():
	var inventory = InventoryManagament.get_items()
	
	for item in inventory:
		if !current_slot:
			return
			
		if !current_slot.is_using_slot():
			var icon_to_set = item_icons.get(item)
			current_slot.set_icon(icon_to_set)
	
		slot_number += 1
		slot_name = "Slot" + str(slot_number)
		current_slot = get_node_or_null(slot_name)
