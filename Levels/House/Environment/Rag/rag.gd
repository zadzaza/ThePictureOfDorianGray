extends Node2D

@onready var rag_node = get_node("Rag")

@onready var nodes = {
	"rag": rag_node
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var pick_area = preload("res://Levels/House/pick_area.tscn").instantiate()
	add_child(pick_area)

func collect_rag(item_name):
	if get_parent() != null:
		
		var item_comment: String
		
		if Dialogic.VAR.rag_state == "not_has":
			item_comment = "Пахнет вкусно"
			ItemsManager.pick_item(item_name, nodes)
			self.queue_free()
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)

#func remove_rag(item_name):
	#var item_comment: String
	#
	#if Dialogic.VAR.rag_state == "has":
		#item_comment = "Теперь чисто"
		#ItemsManager.done_item(item_name)
		#
	#ItemsManager.start_hint_animation(item_comment, self.global_position)
