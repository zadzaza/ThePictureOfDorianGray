extends GridContainer

@onready var lamp_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/lamp_icon.png")
@onready var corpse_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/corpse_icon.png")
@onready var knife_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/knife_icon.png")
@onready var rag_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/rag_icon.png")
@onready var bird_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/bird_icon.png")
@onready var case_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/case_icon.png")
@onready var coat_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/coat_icon.png")
@onready var curtain_icon = preload("res://UI/UIBookMenu/v2/Sprites/icons/curtain_icon.png")

@onready var items_icons = {
	"lamp": lamp_icon,
	"corpse": corpse_icon,
	"knife": knife_icon,
	"rag": rag_icon,
	"bird": bird_icon,
	"case": case_icon,
	"coat": coat_icon,
	"curtain": curtain_icon
}
@onready var items_names = {
	"lamp": "Лампа",
	"corpse": "Труп",
	"knife": "Нож",
	"rag": "Тряпка",
	"bird": "Птица",
	"case": "Саквояж",
	"coat": "Пальто",
	"curtain": "Штора"
}

func _ready():
	refresh_slots()

func refresh_slots():
	var slot_number = 1
	var slot_name = "Slot" + str(slot_number)
	var current_slot = get_node_or_null(slot_name)
	
	var inventory = InventoryManager.get_items()
	
	for item in inventory:
		if !current_slot:
			return
			
		if !current_slot.is_using_slot():
			var icon_to_set = items_icons.get(item)
			current_slot.set_icon(icon_to_set)
			current_slot.set_slot_name(items_names.get(item))
	
		slot_number += 1
		slot_name = "Slot" + str(slot_number)
		current_slot = get_node_or_null(slot_name)
