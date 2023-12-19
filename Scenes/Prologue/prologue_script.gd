extends Node2D

func _process(delta):
	if Input.is_action_pressed("piska_1") and Input.is_action_pressed("piska_2") and Input.is_action_pressed("piska_3"):
		$PointLight2D.enabled = true
	else: $PointLight2D.enabled = false
