extends StaticBody2D


@onready var items_complete = {
	"coat": false,
	"lamp": false,
	"knife": false,
	"bag": false
}

var in_chest_area = false

@onready var pick_area = get_node("PickArea")

func _input(event):
	if event.is_action_pressed("e"):
		if in_chest_area:
			chest_open()

func chest_open():
	$AnimatedSprite2D.play("opened")
	
func chest_close():
	$AnimatedSprite2D.play("closed")

func remove_coat(item_name):
	var item_comment: String
	
	if Dialogic.VAR.coat_state == "has":
		ItemsManager.done_item(item_name)
		
		$AnimatedSprite2D.play("closed")
		items_complete["coat"] = true
	
		start_closing_phrase_or_no()

func remove_lamp(item_name):
	get_parent().get_node("PlayerXY").drop_lamp()
	var item_comment: String
	
	if Dialogic.VAR.lamp_state == "has":
		ItemsManager.done_item(item_name)
		
		$AnimatedSprite2D.play("closed")
		items_complete["lamp"] = true
	
		start_closing_phrase_or_no()

func remove_knife(item_name):
	var item_comment: String
	
	if Dialogic.VAR.knife_state == "has":
		item_comment = "Орудие убийства спрятано"
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		$AnimatedSprite2D.play("closed")
		items_complete["knife"] = true
	
		start_closing_phrase_or_no()

func remove_bag(item_name):
	var item_comment: String
	
	if Dialogic.VAR.bag_state == "has":
		ItemsManager.done_item(item_name)
		
		$AnimatedSprite2D.play("closed")
		items_complete["bag"] = true
	
		start_closing_phrase_or_no()

func start_closing_phrase_or_no():
	var are_all_items_complete = ItemsManager.are_all_items_complete(items_complete)
	var closing_phrase = "Теперь я запру сундук раз и навсегда"
	
	if are_all_items_complete:
		in_chest_area = false
		$Area2D.queue_free()
		pick_area.queue_free()
		await get_tree().create_timer(1.5).timeout
		ItemsManager.start_hint_animation(closing_phrase, self.global_position)
	else: return

func _on_area_2d_body_entered(body):
	chest_open()
	in_chest_area = true
	print($Area2D.get_overlapping_bodies())

func _on_area_2d_body_exited(body):
	chest_close()
	in_chest_area = false
