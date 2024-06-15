extends Node2D

@onready var hint_animation_scene = preload("res://UI/HintAnimation/hint_animation.tscn")

@onready var area = $Area2D

@onready var parent = get_parent()
@onready var table_parent = preload("res://Levels/House/Environment/Table/table.tscn").instantiate()
@onready var rag_parent = preload("res://Levels/House/Environment/Rag/rag.tscn").instantiate()
@onready var coat_rack_parent = preload("res://Levels/House/Environment/Coat/coat_rack.tscn").instantiate()
@onready var fireplace_parent = preload("res://Levels/House/Fire/fireplace.tscn").instantiate()
@onready var chest_parent = preload("res://Levels/House/Environment/Chest/chest.tscn").instantiate()
@onready var window_parent = preload("res://Levels/House/Environment/Window/window.tscn").instantiate()
@onready var portrait_parent = preload("res://Levels/House/Environment/Portrait/portrait.tscn").instantiate()

var player_in_pick_area: bool
@onready var timeline_to_start: String

func _ready():
	
	area.body_entered.connect(_on_pick_area_body_entered)
	area.body_exited.connect(_on_pick_area_body_exited)
	initialize_timeline()
	Dialogic.signal_event.connect(_on_choice_selected)

func _input(event):
	if event.is_action_pressed("e") and player_in_pick_area:
		Dialogic.start(timeline_to_start + "_choice")

func initialize_timeline():
	if parent.name == rag_parent.name:
		timeline_to_start = "rag"
	elif parent.name == table_parent.name:
		timeline_to_start = "table"
	elif parent.name == coat_rack_parent.name:
		timeline_to_start = "coat_rack"
	elif parent.name == fireplace_parent.name:
		timeline_to_start = "fireplace"
	elif parent.name == chest_parent.name:
		timeline_to_start = "chest"
	elif parent.name == window_parent.name:
		timeline_to_start = "curtain"
	elif parent.name == portrait_parent.name:
		timeline_to_start = "portrait"

func _on_pick_area_body_entered(body):
	player_in_pick_area = true
	
func _on_pick_area_body_exited(body):
	player_in_pick_area = false
	Dialogic.end_timeline()

func _on_choice_selected(selected_choice: String):
	manage_choice(selected_choice)

func manage_choice(choice_name: String):
	var item_comment: String
	var item_name: String
	
	match choice_name:
		"lamp_has":
			item_name = "lamp"
			if parent.name == table_parent.name:
				parent.collect_lamp(item_name)
		"lamp_done":
			item_name = "lamp"
			if parent.name == chest_parent.name:
				parent.remove_lamp(item_name)
		"corpse_has":
			item_name = "corpse"
			if parent.name == table_parent.name:
				parent.collect_corpse(item_name)
		"corpse_done":
			item_name = "corpse"
			if parent.name == fireplace_parent.name:
				parent.remove_corpse(item_name)
		"knife_has":
			item_name = "knife"
			if parent.name == table_parent.name:
				parent.collect_knife(item_name)
		"knife_done":
			item_name = "knife"
			if parent.name == chest_parent.name:
				parent.remove_knife(item_name)
		"rag_has":
			item_name = "rag"
			if parent.name == rag_parent.name:
				parent.collect_rag(item_name)
		"rag_done":
			item_name = "rag"
			if parent.name == table_parent.name:
				parent.remove_rag(item_name)
		"coat_has":
			item_name = "coat"
			if parent.name == coat_rack_parent.name:
				parent.collect_coat(item_name)
		"coat_done":
			item_name = "coat"
			if parent.name == chest_parent.name:
				parent.remove_coat(item_name)
		"bag_has":
			item_name = "bag"
			if parent.name == coat_rack_parent.name:
				parent.collect_bag(item_name)
		"bag_done":
			item_name = "bag"
			if parent.name == chest_parent.name:
				parent.remove_bag(item_name)
		"curtain_has":
			item_name = "curtain"
			if parent.name == window_parent.name:
				parent.collect_curtain(item_name)
		"curtain_done":
			item_name = "curtain"
			if parent.name == portrait_parent.name:
				parent.remove_curtain(item_name)
