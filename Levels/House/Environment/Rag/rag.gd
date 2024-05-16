extends Node2D

@onready var hint_animation_scene = preload("res://UI/HintAnimation/hint_animation.tscn")

@onready var rag_area = %RagArea
@onready var rag = $Sprite2D
var player_in_rag_area: bool

func _ready():
	rag_area.body_entered.connect(_on_rag_body_entered)
	rag_area.body_exited.connect(_on_rag_body_exited)
	Dialogic.signal_event.connect(_on_item_selected)

func _input(event):
	if event.is_action_pressed("e") and player_in_rag_area:
		Dialogic.start("rag_choice")

func _on_rag_body_entered(body):
	player_in_rag_area = true
	
func _on_rag_body_exited(body):
	player_in_rag_area = false
	Dialogic.end_timeline()

func _on_item_selected(selected_item: String):
	if selected_item == "rag" and Dialogic.VAR.rag_state == "not_has":
		InventoryManager.remove_item_node(selected_item, rag)
		ItemsManager.pick_item(selected_item)
		create_item_description(selected_item)

func create_item_description(item_name: String):
	var hint_animation = hint_animation_scene.instantiate() as Node2D
	add_child(hint_animation)
	
	var item_hint: String
	var item_comment: String
	
	item_hint = "Когда со всем закончу, надо будет вернуть лампу на стол"
	item_comment = "Тряпка пахнет вкусно"
		
	InventoryManager.put_item(item_name)
	hint_animation.start_hint_animation.emit(item_comment, self.global_position)
