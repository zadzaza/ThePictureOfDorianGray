extends Node2D

@onready var path_follow = $Path2D/PathFollow2D
@onready var camera_pl = $Path2D/PathFollow2D/PlayerScene/PlCamera
@onready var camera_world = $WorldCamera
@onready var player = $Path2D/PathFollow2D/PlayerScene

var speed = 0.0

func _ready():
	camera_world.make_current()
	
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
	if path_follow.progress_ratio == 1.0:
		camera_pl.make_current()

