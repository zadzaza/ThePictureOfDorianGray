extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Attention.modulate = Color(1, 1, 1, 0)
	$Creators/VBoxContainer/NagIgroyRabotali.modulate = Color(1, 1, 1, 0)	
	$Creators/VBoxContainer/Avilov.modulate = Color(1, 1, 1, 0)
	$Creators/VBoxContainer/Koryakina.modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween()
	
	tween.tween_property($Creators/VBoxContainer/NagIgroyRabotali, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	tween.tween_property($Creators/VBoxContainer/Avilov, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	tween.tween_property($Creators/VBoxContainer/Koryakina, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	
	tween.tween_property($Creators, "modulate", Color(1, 1, 1, 0), 1.5).from(Color(1, 1, 1, 1))
	
	tween.tween_property($Attention, "modulate", Color(1, 1, 1, 1), 2.0).from(Color(1, 1, 1, 0))
	
	tween.tween_property($Attention, "modulate", Color(1, 1, 1, 0), 2.0).from(Color(1, 1, 1, 1))
	
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")
