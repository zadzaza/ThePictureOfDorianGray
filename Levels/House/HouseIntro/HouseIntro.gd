extends Node2D


func _ready():
	Dialogic.start("house_intro_timeline")
	Dialogic.signal_event.connect(_on_house_intro_ended)


func _on_house_intro_ended(param: String):
	if param == "house_intro_ended":
		var tween = create_tween()
		tween.tween_property($ColorRect, "modulate", Color(0, 0, 0, 1), 1.0)
		await tween.finished
		get_tree().change_scene_to_file("res://Levels/House/House.tscn")
