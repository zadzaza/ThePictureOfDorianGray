extends CharacterBody2D

# Инициализируем анимированный спрайт и его поведение при повороте
@onready var animation = $AnimatedSprite2D
@onready var pl_flip_h: bool
var show_btn = false
var block_movement = false
@export var pepe = true

var path_going = true

# Константы для скорости и гравитации
const SPEED = 1500.0
const GRAVITY = 1000.0

# Перечисление состояний движения персонажа
enum MOVE_STATE {IDLE_SIDE, IDLE_UP, IDLE_DOWN, MOVE_SIDE, MOVE_UP, MOVE_DOWN}

# Инициализация текущего состояния движения персонажа
@export var move_state = MOVE_STATE.IDLE_SIDE


func _physics_process(delta):
	# Получаем направление движения из пользовательского ввода
	var direction = Input.get_axis("ui_left", "ui_right") if !Dialogic.VAR.block_movement else 0.0
	
	# Устанавливаем горизонтальную скорость, если есть направление движения
	if direction:
		velocity.x = direction * SPEED
	else:
		# Иначе плавно останавливаем персонажа
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Для размещения персонажа используется упрощённая гравитация.
	if not is_on_floor():
		velocity.y += GRAVITY
  
	# Определяем, нужно ли отразить спрайт по горизонтали, исходя из направления движения
	if velocity.x > 0:
		pl_flip_h = false
	if velocity.x < 0:
		pl_flip_h = true
	
	$AnimatedSprite2D.flip_h = pl_flip_h
	
	if path_going:
		var parent = get_parent()
		if parent != null:
			if parent.progress_ratio > 0.0:
				set_anim(MOVE_STATE.MOVE_SIDE)
				$AnimatedSprite2D.set_speed_scale(0.77)
			if parent.progress_ratio == 1.0:
				path_going = false
				$AnimatedSprite2D.set_speed_scale(1.0)
		
			if parent.progress_ratio != 1.0:
				set_block_movement(true)
			else: 
				set_block_movement(false)
  
	# Установка анимации в условием того, что персонаж двигается
	if !path_going and !block_movement:
		if velocity.x:
			set_anim(MOVE_STATE.MOVE_SIDE)
		else:
			set_anim(MOVE_STATE.IDLE_SIDE)
	
	# Перемещаем персонажа и выводим текущее состояние и позицию в консоль
	move_and_slide()

# Устанавливаем новое состояние анимации персонажа
func set_anim(new_state: MOVE_STATE):
	move_state = new_state
	
	# Выбираем анимацию на основе состояния персонажа
	match move_state:
		MOVE_STATE.IDLE_SIDE:
			animation.set_animation("idle_side")
		MOVE_STATE.MOVE_SIDE:
			animation.set_animation("move_side")
		MOVE_STATE.IDLE_UP:
			animation.set_animation("idle_up")

func set_block_movement(block: bool):
	block_movement = block

func set_btn_visible(btn_visible: bool, btn_animation: String):
	%Button.set_visible(btn_visible)
	%Button.set_animation(btn_animation)
