extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	open()

func _on_yes_button_pressed():
	self_parent_close()
	DbManager.execute_query("DELETE FROM choices WHERE user_id = {user_id}".format({"user_id":DbManager.current_id}))

func _on_no_button_pressed():
	self_close()

func open() -> void:
	var tween = create_tween()
	
	tween.tween_property(
		self, 'scale', Vector2.ZERO, 0
	)
	tween.tween_property(
		self, 'scale', Vector2.ONE, .3
	).set_ease(
		Tween.EASE_OUT
	).set_trans(
		Tween.TRANS_BACK
	)

func self_close() -> void:
	var tween = create_tween()
	tween.tween_property(
		self, 'scale', Vector2.ONE, 0
	)
	tween.tween_property(
		self, 'scale', Vector2.ZERO, .3
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_BACK
	)
	
	await tween.finished
	queue_free()

func self_parent_close() -> void:
	var tween = create_tween()
	tween.tween_property(
		self, 'scale', Vector2.ONE, 0
	)
	tween.tween_property(
		self, 'scale', Vector2.ZERO, .3
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_BACK
	)
	
	await tween.finished
	get_parent().ending = "not_complete"
	get_parent().close_to_prolog()
	queue_free()
