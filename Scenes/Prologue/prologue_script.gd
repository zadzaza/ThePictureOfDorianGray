extends Node2D

func _process(delta):
	if Input.is_action_pressed("piska_1") and Input.is_action_pressed("piska_2") and Input.is_action_pressed("piska_3"):
		$PlayerScene/Prizrak.enabled = true
	else: $PlayerScene/Prizrak.enabled = false
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/prologue.dialogue"), "start")
