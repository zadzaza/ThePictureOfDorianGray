extends Node2D


var reflection_change: float
@onready var camera_change = $PlayerScene/Camera2D2.get_position().y

var camera_original = 0
var reflection_original = 0.306

var material1 = load("res://Scenes/Prologue/shaders/water_reflection.gdshader")

func _ready():
	$AnimationPlayer.play("light_up")
	#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")

func _input(event):
	if event.is_action_pressed("piska_1") and event.is_action_pressed("piska_2") and event.is_action_pressed("piska_3"):
		$PlayerScene/Prizrak.enabled = true
	else: $PlayerScene/Prizrak.enabled = false
	
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()

