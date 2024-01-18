extends Node2D

func _process(delta):
	pass
	
func _ready():
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")

func _input(event):
	if event.is_action_pressed("piska_1") and event.is_action_pressed("piska_2") and event.is_action_pressed("piska_3"):
		$PlayerScene/Prizrak.enabled = true
	else: $PlayerScene/Prizrak.enabled = false
	
	if event.is_action_pressed("ui_cancel"):
		%UIBookMenu.show()
