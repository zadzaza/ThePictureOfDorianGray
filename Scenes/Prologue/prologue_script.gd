extends Node2D

# Переменные
@onready var player_path_follow = $Path2D/PathFollow2D
@onready var henry_path_follow = $PathHenry/PathFollowHenry
@onready var bird_text = %BirdDialogue.text

var in_bird_area = false # Если true и нажимается клавиша E, птица добавляется в инвентарь и удаляется со сцены (строка 79)
var in_put_area = false
var in_besedka_area = false
var in_penek_area = false

var bird = load("res://Scenes/Prologue/fly_bird.tscn") # Экспорт птицы
var text_bird_count_line = 0
var speed_pl_follow = 0.0 # Начальная скорость. Когда  равна 0.1, начинается движение (строка 66)
var speed_hr_follow = 0.0
var qte_activated = false

var shot_penek1 = true
var shot_penek2 = true

var besedka_dialog_state = "first"

enum CAMERA_STATE {SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM}

func _ready():
	show_transition_animation()
	hide_lables()
	

func _input(event):
	handle_qte(event)
	handle_cancel_input(event)
	handle_prizrak_visibility(event)
	handle_interaction(event)

func _process(delta):
	start_follow_path(delta)
	
	if Dialogic.VAR.prologue_timeline_finish == true: # После завершения первого диалога появляется qte повернуть голову вправо
		Dialogic.VAR.prologue_timeline_finish = false
		%AnimationBasilQTE.play("typing_qte")
		%AnimationSunset.play("sunset_anim")
		await %AnimationBasilQTE.animation_finished
		%Player.set_btn_visible(true, "right")
		qte_activated = true
	
	if Dialogic.VAR.go_to_penek_timeline_finish == true:
		speed_hr_follow = 0.15
		Dialogic.VAR.go_to_penek_timeline_finish = false
	
	if Dialogic.VAR.finish_prolog == true:
		%TransitionAnimation.play("fade_out")
		Dialogic.VAR.finish_prolog = false

func start_follow_path(delta):
	player_path_follow.progress_ratio += delta * speed_pl_follow
	henry_path_follow.progress_ratio += delta * speed_hr_follow

#Скрыть надписи вначале игры
func hide_lables():
	%BirdDialogue.hide()
	%ButtonsHelp.hide()
	
# Таймер появления птиц
func _on_bird_timer_timeout():
	spawn_bird()

# При попадании в зону птицы удаляются
func _on_birds_remove_area_body_entered(body):
	body.queue_free()

func _on_bird_area_body_entered(body):
	animate_bird_appearance()

func _on_bird_area_body_exited(body):
	%BirdArea.queue_free()

func _on_animation_bird_animation_finished(anim_name):
	update_bird_dialogue()

func _on_buttons_help_area_body_entered(body):
	animate_buttons_help_appearance()

func _on_buttons_help_area_body_exited(body):
	remove_buttons_help()
	remove_animation_buttons()

# Подошел к птице
func _on_area_bird_take_body_entered(body):
	%Player.set_btn_visible(true, "e")
	in_bird_area = true

# Отошел от птицы
func _on_area_bird_take_body_exited(body):
	%Player.set_btn_visible(false, "e")
	in_bird_area = false

# Подошел к гнезду
func _on_area_bird_put_body_entered(body):
	%Player.set_btn_visible(true, "e")
	in_put_area = true

# Отошел от гнезда
func _on_area_bird_put_body_exited(body):
	%Player.set_btn_visible(false, "e")
	in_put_area = false

# Подошел к беседке
func _on_start_besedka_dialogue_body_entered(body):
	%Player.set_btn_visible(true, "e")
	in_besedka_area = true

# Отошел от беседки
func _on_start_besedka_dialogue_body_exited(body):
	%Player.set_btn_visible(false, "e")
	in_besedka_area = false

func _on_penek_area_body_entered(body):
	%Player.set_btn_visible(true, "e")
	in_penek_area = true

func _on_penek_area_body_exited(body):
	%Player.set_btn_visible(false, "e")
	in_penek_area = false

# Начальный переход
func show_transition_animation():
	$MainCanvasLayer/Transition.show()
	%TransitionAnimation.play("light_up")
	await %TransitionAnimation.animation_finished
	$MainCanvasLayer/Transition.hide()
	speed_pl_follow = 0.1

func handle_qte(event):
	if event.is_action_pressed("ui_right") and qte_activated:
		qte_activated = false
		%Player.pl_flip_h = false
		%Player.set_btn_visible(false, "e")
		%Player.set_anim(%Player.MOVE_STATE.IDLE_SIDE)
		await get_tree().create_timer(0.5).timeout
		%AnimationBasilQTE.play("fade_out")
		await %AnimationBasilQTE.animation_finished
		%AnimationBasilQTE.queue_free()
		%BasilQTEDialogue.queue_free()
		await get_tree().create_timer(6.5).timeout
		Dialogic.start("GoToPenekDialog")

func handle_cancel_input(event):
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()

func handle_prizrak_visibility(event):
	if event.is_action_pressed("[") and event.is_action_pressed("e") and event.is_action_pressed("q"):
		%Prizrak.show()
	else:
		%Prizrak.hide()

func handle_interaction(event):
	if event.is_action_pressed("e"):
		if in_bird_area: # В зоне взаимодействия с птицей
			%UIBookMenu.show_item(true)
			%Chick.hide()
			%AreaBirdTake.queue_free()
			%AreaBirdPut.set_monitoring(true)
			%Player.set_btn_visible(false, "e")
		if in_put_area: # В зоне взаимодействия с гнездом
			%UIBookMenu.show_item(false)
			%TreeWithBird.set_animation("bird_put")
			%AreaBirdPut.queue_free()
			%Player.set_btn_visible(false, "e")
		if in_besedka_area: # В зоне взаимодействия с беседкой
			if besedka_dialog_state == "first":
				%StartBesedkaDialogue.set_monitoring(false)
				%Player.set_block_movement(true)
				%Player.set_anim(%Player.MOVE_STATE.IDLE_UP)
				%Player.set_btn_visible(false, "e")
				besedka_dialog_state = "second"
				Dialogic.start("PrologueTimeline")
			if besedka_dialog_state == "second":
				%StartBesedkaDialogue.set_monitoring(false)
				Dialogic.start("LastDialog")
				%Player.set_block_movement(true)
		if in_penek_area:
			if Dialogic.VAR.penek_dialog_state == "none" and shot_penek1:
				%Player.set_btn_visible(false, "e")
				Dialogic.start("PenekDialogWithoutBird")
				shot_penek1 = false
				%StartBesedkaDialogue.set_monitoring(true)
				%Player.set_block_movement(true)
			if Dialogic.VAR.penek_dialog_state == "first_finish" and shot_penek2 and Dialogic.VAR.have_bird:
				%Player.set_btn_visible(false, "e")
				Dialogic.start("PenekDialogWithBird")
				shot_penek2 = false
				%Player.set_block_movement(true)
			if Dialogic.VAR.penek_dialog_state == "second_finish":
				Dialogic.start("NoQuestion")
				%Player.set_anim(%Player.MOVE_STATE.IDLE_UP)
				%Player.set_block_movement(true)

func spawn_bird():
	var new_bird_instance = bird.instantiate()
	var bird_spawn_location = $BirdPath/BirdSpawnLocation
	bird_spawn_location.progress_ratio = randf()
	new_bird_instance.position = bird_spawn_location.position
	add_child(new_bird_instance)

func animate_bird_appearance():
	%AnimationBird.play("fade_in_take_bird")

func update_bird_dialogue():
	text_bird_count_line += 1
	if text_bird_count_line == 1:
		$BirdDialogue.set_text("Ваши поступки влияют на характер главного героя")
		%AnimationBird.play("fade_in_take_bird")
		await %AnimationBird.animation_finished

# Анимация подсказки об управлении
func animate_buttons_help_appearance():
	%AnimationButtons.play("fade_in")

# Удаление зоны с подсказкой об управлении
func remove_buttons_help():
	%ButtonsHelpArea.queue_free()

# Удаление подсказки об управлении
func remove_animation_buttons():
	%AnimationButtons.play("fade_out")
	await %AnimationButtons.animation_finished
	%ButtonsHelp.queue_free()
	%AnimationButtons.queue_free()
