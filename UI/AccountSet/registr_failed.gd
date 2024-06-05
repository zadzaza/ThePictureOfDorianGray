extends Control

func _ready():
	open()

func _on_button_pressed():
	close()

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

func close() -> void:
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
