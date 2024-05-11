extends StaticBody2D

@onready var table_area = %TableArea
@onready var table_anim = %TablleAnim
@onready var corpse_sprite = %CorpseSprite

@onready var hint_animation_scene = preload("res://UI/HintAnimation/hint_animation.tscn")

var player_in_table_area: bool

func _ready():
	table_area.body_entered.connect(_on_table_body_entered)
	table_area.body_exited.connect(_on_table_body_exited)
	Dialogic.signal_event.connect(_on_item_selected)

func _input(event):
	if event.is_action_pressed("e") and player_in_table_area:
		Dialogic.start("table_choice")

func _on_table_body_entered(body):
	player_in_table_area = true
	
func _on_table_body_exited(body):
	player_in_table_area = false
	Dialogic.end_timeline()

func _on_item_selected(selected_item: String):
	create_item_description(selected_item)

func create_item_description(item_name: String):
	var hint_animation = hint_animation_scene.instantiate() as Node2D
	add_child(hint_animation)
	
	var item_hint: String
	var item_comment: String
	
	match item_name:
		"Лампа":
			item_hint = "Когда со всем закончу, надо будет вернуть лампу на стол"
			item_comment = "С лампой я не переломаю себе ноги"
		"Труп":
			item_hint = "Надо бы сжечь Бэзила..."
			item_comment = "Бедный Бэзил... Ну ничего не поделаешь"
		
	InventoryManagament.put_item(item_name)
	hint_animation.start_hint_animation.emit(item_comment, self.global_position)
	
