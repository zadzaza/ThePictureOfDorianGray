extends Node2D

@onready var items_complete = {
	"curtain": false
}

var pick_area = preload("res://Levels/House/pick_area2.tscn").instantiate()

func _ready():
	add_child(pick_area)
	$Curtain.hide()


func remove_curtain(item_name):
	var item_comment: String
	
	if Dialogic.VAR.curtain_state == "has":
		ItemsManager.done_item(item_name)
		
		$NotCurtain.hide()
		$Curtain.show()
		pick_area.queue_free()
		
		items_complete["curtain"] = true
		
		item_comment = "Портрет - виновник всех бед"
		ItemsManager.start_hint_animation(item_comment, self.global_position)
