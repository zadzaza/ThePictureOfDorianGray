extends Node2D


@onready var placeholder_node = $Node2D

@onready var nodes = {
	"placeholder": placeholder_node
}
@onready var items_complete = {
	"curtain": false
}

@onready var pick_area = get_node("PickArea")

func collect_curtain(item_name):
	var item_comment: String
	
	if Dialogic.VAR.curtain_state == "not_has":
		item_comment = "Я забыл укрыть портрет"
		ItemsManager.pick_item(item_name, nodes)
		
		$AnimatedSprite2D.play("porvano")
		pick_area.queue_free()
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)
		items_complete["curtain"] = true
