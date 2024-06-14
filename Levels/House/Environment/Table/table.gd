extends StaticBody2D


@onready var corpse_node = $Corpse
@onready var lamp_node = $Lamp
@onready var knife_node = $Knife

@onready var nodes = {
	"corpse": corpse_node,
	"lamp": lamp_node,
	"knife": knife_node
}
@onready var items_complete = {
	"corpse": false,
	"lamp": false,
	"knife": false,
	"rag": false
}

var pick_area = preload("res://Levels/House/pick_area2.tscn").instantiate()

func _ready():
	add_child(pick_area)


func collect_corpse(item_name):
	var item_comment: String
	
	if Dialogic.VAR.corpse_state == "not_has":
		item_comment = "Труп! Я должен превратить его в горсточку пепла, \nкоторую можно развеять по ветру"
		ItemsManager.pick_item(item_name, nodes)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		items_complete["corpse"] = true
		
		start_closing_phrase_or_no()

func collect_lamp(item_name):
	var item_comment: String
	
	if Dialogic.VAR.lamp_state == "not_has":
		item_comment = "Лампа. Мавританская работа, из темного серебра.\n Ее исчезновение из библиотеки могло быть замечено прислугой, вызвать вопросы."
		ItemsManager.pick_item(item_name, nodes)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		items_complete["lamp"] = true
		
		start_closing_phrase_or_no()

func collect_knife(item_name):
	var item_comment: String
	
	if Dialogic.VAR.knife_state == "not_has":
		item_comment = "Нельзя оставлять орудие убийства прямо тут…"
		ItemsManager.pick_item(item_name, nodes)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		items_complete["knife"] = true
		
		start_closing_phrase_or_no()

func remove_rag(item_name):
	var item_comment: String
	
	if Dialogic.VAR.rag_state == "has":
		item_comment = "Теперь чисто"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$TablleAnim.set_animation("clear")
		items_complete["rag"] = true
	
		start_closing_phrase_or_no()

func start_closing_phrase_or_no():
	var are_all_items_complete = ItemsManager.are_all_items_complete(items_complete)
	var closing_phrase = "Мертвый человек, сидевший у стола, исчез"
	
	if are_all_items_complete:
		pick_area.queue_free()
		await get_tree().create_timer(3.0).timeout
		ItemsManager.start_hint_animation(closing_phrase, self.global_position)
	else: return
