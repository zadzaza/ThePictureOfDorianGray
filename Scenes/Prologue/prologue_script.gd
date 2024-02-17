extends Node2D

var material1 = load("res://Scenes/Prologue/shaders/water_reflection.gdshader")
@onready var path_follow = $Path2D/PathFollow2D
var go_to_path = false

func _ready():
	$MainCanvasLayer/Transition.set_visible(true)
	$AnimationTree/TransitionAnimation.play("light_up")
	await $AnimationTree/TransitionAnimation.animation_finished
	$MainCanvasLayer/Transition.set_visible(false)
	go_to_path = true
	#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()

func _process(delta):
	if go_to_path:
		path_follow.progress_ratio += delta * 0.1
