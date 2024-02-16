extends Node2D

var material1 = load("res://Scenes/Prologue/shaders/water_reflection.gdshader")
@onready var path_follow = $Path2D/PathFollow2D

func _ready():
	$MainCanvasLayer/Transition.set_visible(true)
	$AnimationPlayer.play("light_up")
	await $AnimationPlayer.animation_finished
	$MainCanvasLayer/Transition.set_visible(false)
	#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()

func _process(delta):
	pass
	#path_follow.progress_ratio += delta * 0.1
