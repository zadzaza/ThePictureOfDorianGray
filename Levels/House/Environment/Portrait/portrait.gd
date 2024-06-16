extends Node2D

@onready var items_complete = {
	"curtain": false
}

@onready var pick_area = get_node("PickArea")

func _ready():
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
