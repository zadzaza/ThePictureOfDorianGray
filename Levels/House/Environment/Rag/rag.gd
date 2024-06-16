extends Node2D

@onready var rag_node = get_node("Rag")

@onready var nodes = {
	"rag": rag_node
}

@onready var pick_area = get_node("PickArea")

func collect_rag(item_name):
	if get_parent() != null:
		
		var item_comment: String
		
		if Dialogic.VAR.rag_state == "not_has":
			item_comment = "Вонючая тряпка. \nЕю можно вытереть кровь со стола"
			ItemsManager.pick_item(item_name, nodes)
			self.queue_free()
		
		ItemsManager.start_hint_animation(item_comment, self.global_position + Vector2(0, -60))

#func remove_rag(item_name):
	#var item_comment: String
	#
	#if Dialogic.VAR.rag_state == "has":
		#item_comment = "Теперь чисто"
		#ItemsManager.done_item(item_name)
		#
	#ItemsManager.start_hint_animation(item_comment, self.global_position)
