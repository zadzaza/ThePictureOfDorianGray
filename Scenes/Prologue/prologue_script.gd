extends Node2D

@onready var path_follow = $Path2D/PathFollow2D
@onready var bird_text = $BirdDialogue.text

var bird = load("res://Scenes/Prologue/fly_bird.tscn")

var text_bird_count_line = 0

var speed = 0.0

func _ready():
	$BirdDialogue.set_text("С некоторыми объектами можно взаимодействовать. \nДля этого нажмите E")
	
	$MainCanvasLayer/Transition.set_visible(true)
	$AnimationTree/TransitionAnimation.play("light_up")
	await $AnimationTree/TransitionAnimation.animation_finished
	$MainCanvasLayer/Transition.set_visible(false)
	speed = 0.1
	#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()

func _process(delta):
	path_follow.progress_ratio += delta * speed


func _on_bird_timer_timeout():
	# Create a new instance of the Mob scene.
	var bird = bird.instantiate()

	# Choose a random location on Path2D.
	var bird_spawn_location = $BirdPath/BirdSpawnLocation
	bird_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	bird.position = bird_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(bird)


func _on_birds_remove_area_body_entered(body):
	body.queue_free()


func _on_bird_area_body_entered(body):
	$AnimationTree/AnimationBird.play("fade_in_take_bird")


func _on_animation_bird_animation_finished(anim_name):
	text_bird_count_line += 1
	if text_bird_count_line == 1:
		bird_text = "Ваши поступки влияют на характер главного героя"
		$BirdDialogue.set_text("Ваши поступки влияют на характер главного героя")
		$AnimationTree/AnimationBird.play("fade_in_take_bird")
