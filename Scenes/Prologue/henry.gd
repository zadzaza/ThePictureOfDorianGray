extends CharacterBody2D

const GRAVITY = 1000.0
var kak_vse_zaebalo = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
	
	var path_node = get_parent()
	
	if !kak_vse_zaebalo:
		if path_node != null:
			if path_node.progress_ratio > 0.0:
				$AnimatedSprite2D.play("move")
				$AnimatedSprite2D.set_flip_h(true)
				$AnimatedSprite2D.set_speed_scale(0.77)
			if path_node.progress_ratio == 1.0:
				$AnimatedSprite2D.set_scale(Vector2(0.77, 0.77))
				$AnimatedSprite2D.play("default")
				await get_tree().create_timer(0.5).timeout
				$AnimatedSprite2D.play("sit")
				kak_vse_zaebalo = true
