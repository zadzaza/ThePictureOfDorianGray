extends Node2D

# Переменные
@onready var path_follow = $Path2D/PathFollow2D
@onready var bird_text = %BirdDialogue.text

var in_bird_area = false # Если true и нажимается клавиша E, птица добавляется в инвентарь и удаляется со сцены (строка 79)
var in_put_area = false
var bird = load("res://Scenes/Prologue/fly_bird.tscn") # Экспорт птицы
var text_bird_count_line = 0
var speed = 0.0 # Начальная скорость ГГ. Когда она равна 0.1, начинается движение (строка 66)


func _ready():
	show_transition_animation()
	hide_lables()

func _input(event):
	handle_cancel_input(event)
	handle_prizrak_visibility(event)
	handle_interaction(event)

func _process(delta):
	path_follow.progress_ratio += delta * speed

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

func _on_area_bird_take_body_entered(body):
	show_btn()
	in_bird_area = true

func _on_area_bird_take_body_exited(body):
	hide_btn()
	in_bird_area = false
	
func _on_area_bird_put_body_entered(body):
	show_btn()
	in_put_area = true
	
func _on_area_bird_put_body_exited(body):
	in_put_area = false

# Начальный переход
func show_transition_animation():
	$MainCanvasLayer/Transition.show()
	$AnimationTree/TransitionAnimation.play("light_up")
	await $AnimationTree/TransitionAnimation.animation_finished
	$MainCanvasLayer/Transition.hide()
	speed = 0.1

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
		if in_bird_area:
			%UIBookMenu.show_item(true)
			%Chick.hide()
			%AreaBirdTake.queue_free()
			%AreaBirdPut.set_monitoring(true)
		if in_put_area:
			%UIBookMenu.show_item(false)
			%TreeWithBird.set_animation("bird_put")

func spawn_bird():
	var new_bird_instance = bird.instantiate()
	var bird_spawn_location = $BirdPath/BirdSpawnLocation
	bird_spawn_location.progress_ratio = randf()
	new_bird_instance.position = bird_spawn_location.position
	add_child(new_bird_instance)

func animate_bird_appearance():
	$AnimationTree/AnimationBird.play("fade_in_take_bird")

func update_bird_dialogue():
	text_bird_count_line += 1
	if text_bird_count_line == 1:
		$BirdDialogue.set_text("Ваши поступки влияют на характер главного героя")
		$AnimationTree/AnimationBird.play("fade_in_take_bird")
		await $AnimationTree/AnimationBird.animation_finished

# Анимация подсказки об управлении
func animate_buttons_help_appearance():
	$AnimationTree/AnimationButtons.play("fade_in")

# Удаление зоны с подсказкой об управлении
func remove_buttons_help():
	%ButtonsHelpArea.queue_free()

# Удаление подсказки об управлении
func remove_animation_buttons():
	$AnimationTree/AnimationButtons.play("fade_out")
	await $AnimationTree/AnimationButtons.animation_finished
	%ButtonsHelp.queue_free()
	%AnimationButtons.queue_free()

# Показ кнопки
func show_btn():
	%Player.show_btn = true

# Скрытие кнопки
func hide_btn():
	%Player.show_btn = false
