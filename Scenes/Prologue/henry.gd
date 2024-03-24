extends CharacterBody2D

const GRAVITY = 1000.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
