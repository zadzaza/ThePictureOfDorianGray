extends Control


@onready var load_screen = load("res://UI/LoadScreen/load_screen.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Я НЕ ВИНОВАТ ЧТО ЕБАНЫЙ ГОДОТ СЛОМАЛ MOUSE_ENTERED, ПОЭТОМУ МНЕ ПРИШЛОСТЬ ПИСАТЬ ЭТУ ХУЙНЮ
	var mouse_pos = get_global_mouse_position()
	$CharacterBody2D.global_position = mouse_pos


func _on_start_button_pressed():
	$Transition.set_visible(true)
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://UI/LoadScreen/load_screen.tscn")


func _on_start_button_house_pressed():
	$Transition.set_visible(true)
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Levels/House/HouseIntro/house_intro.tscn")

func _on_prolog_area_body_entered(body):
	entered_ep($Control/PrologPreviewPanel, $Control/PrologBtn)

func _on_prolog_area_body_exited(body):
	exited_ep($Control/PrologPreviewPanel, $Control/PrologBtn)

func entered_ep(preview_panel: NinePatchRect, btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(preview_panel, "modulate", Color(0, 0, 0, 0.4), 0.2)
	btn.show()

func exited_ep(preview_panel: NinePatchRect, btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(preview_panel, "modulate", Color(1, 1, 1, 1), 0.2)
	btn.hide()

func _on_house_area_body_entered(body):
	entered_ep($Control/HousePreviewPanel, $Control/HouseBtn)

func _on_house_area_body_exited(body):
	exited_ep($Control/HousePreviewPanel, $Control/HouseBtn)

func close() -> void:
	var control = $Control
	var tween = create_tween()
	tween.tween_property(
		control, 'scale', Vector2.ONE, 0
	)
	tween.tween_property(
		control, 'scale', Vector2.ZERO, .3
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_BACK
	)
	
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI/AccountSet/account_login.tscn")

func open() -> void:
	var control = $Control
	var tween = create_tween()
	
	tween.tween_property(
		control, 'scale', Vector2.ZERO, 0
	)
	tween.tween_property(
		control, 'scale', Vector2.ONE, .3
	).set_ease(
		Tween.EASE_OUT
	).set_trans(
		Tween.TRANS_BACK
	)

func _on_house_btn_pressed():
	$Transition.visible = true
	var tween = create_tween()
	tween.tween_property($Transition, "modulate", Color(0, 0, 0, 1), 1)
	await tween.finished
	
	add_child(load_screen)
	load_screen.set_changed_scene("res://Levels/House/HouseIntro/house_intro.tscn")
	
	ItemsManager.reset_house()

func _on_prolog_btn_pressed():
	ItemsManager.reset_prolog()
	
	$Transition.visible = true
	var tween = create_tween()
	tween.tween_property($Transition, "modulate", Color(0, 0, 0, 1), 1)
	await tween.finished
	
	add_child(load_screen)
	load_screen.set_changed_scene("res://Levels/Prologue/prologue_scene.tscn")


func _on_exit_auth_btn_pressed():
	close()
	DbManager.log_out()
