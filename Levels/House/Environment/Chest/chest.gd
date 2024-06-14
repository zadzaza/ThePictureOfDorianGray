extends StaticBody2D


@onready var items_complete = {
	"coat": false,
	"lamp": false,
	"knife": false,
	"bag": false
}

var pick_area = preload("res://Levels/House/pick_area2.tscn").instantiate()

func _ready():
	add_child(pick_area)

func remove_coat(item_name):
	var item_comment: String
	
	if Dialogic.VAR.coat_state == "has":
		item_comment = "Теперь чисто"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$AnimatedSprite2D.play("closed")
		items_complete["coat"] = true
	
		start_closing_phrase_or_no()

func remove_lamp(item_name):
	var item_comment: String
	
	if Dialogic.VAR.lamp_state == "has":
		item_comment = "Теперь чисто"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$AnimatedSprite2D.play("closed")
		items_complete["lamp"] = true
	
		start_closing_phrase_or_no()

func remove_knife(item_name):
	var item_comment: String
	
	if Dialogic.VAR.knife_state == "has":
		item_comment = "Теперь чисто"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$AnimatedSprite2D.play("closed")
		items_complete["knife"] = true
	
		start_closing_phrase_or_no()

func remove_bag(item_name):
	var item_comment: String
	
	if Dialogic.VAR.bag_state == "has":
		item_comment = "Теперь чисто"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$AnimatedSprite2D.play("closed")
		items_complete["bag"] = true
	
		start_closing_phrase_or_no()

func start_closing_phrase_or_no():
	var are_all_items_complete = ItemsManager.are_all_items_complete(items_complete)
	var closing_phrase = "Мертвый человек, сидевший у стола, исчез"
	
	if are_all_items_complete:
		pick_area.queue_free()
		await get_tree().create_timer(3.0).timeout
		ItemsManager.start_hint_animation(closing_phrase, self.global_position)
	else: return

func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("opened")

func _on_area_2d_body_exited(body):
	$AnimatedSprite2D.play("closed")
