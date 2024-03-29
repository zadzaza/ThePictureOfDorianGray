extends CharacterBody2D

const GRAVITY = 1000.0
var kak_vse_zaebalo = false

var path_node: PathFollow2D
var player_node: CharacterBody2D
var main_node: Node2D

func _ready():
	if is_inside_tree():
		path_node = get_parent()
		player_node = get_parent().get_parent().get_parent().get_node("Path2D/PathFollow2D/Player")
		main_node = get_parent().get_parent().get_parent()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
	
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
					player_node.set_block_movement(false)
					main_node.get_node("PenekArea").set_monitoring(true)
