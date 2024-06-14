extends StaticBody2D


@onready var coat_node = $Coat
@onready var bag_node = $Bag

@onready var nodes = {
	"coat": coat_node,
	"bag": bag_node
}
@onready var items_complete = {
	"coat": false,
	"bag": false
}

var pick_area = preload("res://Levels/House/pick_area2.tscn").instantiate()


func _ready():
	add_child(pick_area)

func collect_coat(item_name):
	var item_comment: String
	
	if Dialogic.VAR.coat_state == "not_has":
		item_comment = "Это бежевое пальто — гладкое и элегантное — \nтеперь служит напоминанием о том, \nчто стоило потерять"
		ItemsManager.pick_item(item_name, nodes)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position + Vector2(0, -100))
		items_complete["coat"] = true
		
		start_closing_phrase_or_no()

func collect_bag(item_name):
	var item_comment: String
	
	if Dialogic.VAR.bag_state == "not_has":
		item_comment = "Саквояж Бэзила — старинный, изношенный кожаный чемодан \nс этикетками из разных стран"
		ItemsManager.pick_item(item_name, nodes)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position + Vector2(0, -100))
		items_complete["bag"] = true
		
		start_closing_phrase_or_no()

func start_closing_phrase_or_no():
	var are_all_items_complete = ItemsManager.are_all_items_complete(items_complete)
	var closing_phrase = "Их следует спрятать в укромное место..."
	
	if are_all_items_complete:
		pick_area.queue_free()
		await get_tree().create_timer(3.0).timeout
		ItemsManager.start_hint_animation(closing_phrase, self.global_position + Vector2(0, -100))
	else: return
