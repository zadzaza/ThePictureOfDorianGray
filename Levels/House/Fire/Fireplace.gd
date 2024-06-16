extends Node2D


var pick_area = preload("res://Levels/House/pick_area2.tscn").instantiate()


func _ready():
	add_child(pick_area)
	self.set_visible(false)

func remove_corpse(item_name):
	var item_comment: String
	
	if Dialogic.VAR.corpse_state == "has":
		pick_area.queue_free()
		item_comment = "Прощай, мой друг. \nМне нужно было спасти себя."
		start_fire()
		ItemsManager.done_item(item_name)
		
		ItemsManager.start_hint_animation(item_comment, self.global_position)

func start_fire():
	self.set_visible(true)
	$FireAnimation.play("start")
	$AnimationPlayer.play("start_fire")
	$FireLightAudio.play(0.0)
	await $FireAnimation.animation_finished
	$FireAnimation.play("loop")
	$FireGeneralAudio.play(0.0)
