extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var pl_flip_h = $AnimatedSprite2D

const SPEED = 300.0
enum MOVE_STATE {IDLE_SIDE, IDLE_UP, IDLE_DOWN, MOVE_SIDE, MOVE_UP, MOVE_DOWN}
@onready var move_state = MOVE_STATE.IDLE_SIDE


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		pl_flip_h.flip_h = false
	if velocity.x < 0:
		pl_flip_h.flip_h = true
	
	if velocity.x:
		set_anim(MOVE_STATE.MOVE_SIDE)
	else: set_anim(MOVE_STATE.IDLE_SIDE)

	move_and_slide()
	print(MOVE_STATE)
	print(global_position)


func set_anim(new_state: MOVE_STATE):
	move_state = new_state
	
	match move_state:
		MOVE_STATE.IDLE_SIDE:
			animation.animation = "idle_side"
		MOVE_STATE.MOVE_SIDE:
			animation.animation = "move_side"

