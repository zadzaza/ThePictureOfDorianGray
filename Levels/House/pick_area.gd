extends Area2D


@onready var hint_animation_scene = preload("res://UI/HintAnimation/hint_animation.tscn")

@onready var parent = self.get_parent()

@onready var table_parent = preload("res://Levels/House/Environment/Table/table.tscn").instantiate()
@onready var rag_parent = preload("res://Levels/House/Environment/Rag/rag.tscn").instantiate()

@onready var corpse_node: Node2D
@onready var lamp_node: Node2D
@onready var knife_node: Node2D

@onready var rag_node: Node2D

@onready var parent_nodes = {
	# Возможные ноды в словаре
	
	#"corpse": corpse_node,
	#"lamp": lamp_node,
	#"knife": knife_node
	
	#"rag": rag_node
}

var player_in_pick_area: bool
var timeline_to_start: String

func _ready():
	self.body_entered.connect(_on_pick_area_body_entered)
	self.body_exited.connect(_on_pick_area_body_exited)
	Dialogic.signal_event.connect(_on_item_selected)
	initialize_parent_node()

func _input(event):
	if event.is_action_pressed("e") and player_in_pick_area:
		Dialogic.start(timeline_to_start, "_choice")

func initialize_parent_node():
	if parent != null:
		print("РАБОТАЕТ")
		if parent == table_parent:
			corpse_node = parent.get_node("Corpse")
			lamp_node = parent.get_node("Lamp")
			knife_node = parent.get_node("Knife")
			parent_nodes["corpse"] = corpse_node
			parent_nodes["lamp"] = lamp_node
			parent_nodes["knife"] = knife_node
			
			timeline_to_start = "table"
		elif parent == rag_parent:
			rag_node = parent.get_node("Rag")
			parent_nodes["rag"] = rag_node
			
			timeline_to_start = "rag"

func _on_pick_area_body_entered(body):
	player_in_pick_area = true
	
func _on_pick_area_body_exited(body):
	player_in_pick_area = false
	Dialogic.end_timeline()

func _on_item_selected(selected_item: String):
	create_item_description(selected_item)

func create_item_description(item_name: String):
	
	var hint_animation = hint_animation_scene.instantiate() as Node2D
	add_child(hint_animation)
	
	var item_hint: String
	var item_comment: String
	
	match item_name:
		"lamp":
			item_comment = "С лампой я не переломаю себе ноги"
			pick_item(item_name)
		"corpse":
			item_comment = "Бедный Бэзил... Ну ничего не поделаешь"
			pick_item(item_name)
		"knife":
			item_comment = "Нож весь в крови..."
			pick_item(item_name)
		"rag":
			if Dialogic.VAR.rag_state == "not_has":
				item_comment = "Пахнет вкусно"
				pick_item(item_name)
			elif Dialogic.VAR.rag_state == "has":
				item_comment = "Теперь чисто"
				done_item(item_name)
		
	
	hint_animation.start_hint_animation.emit(item_comment, self.global_position)

func pick_item(item_name):
	InventoryManager.put_item(item_name)
	InventoryManager.remove_item_node(item_name, parent_nodes.get(item_name))
	ItemsManager.set_has(item_name)

func done_item(item_name):
	InventoryManager.erase_item(item_name)
	ItemsManager.set_done(item_name)
