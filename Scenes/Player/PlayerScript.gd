extends CharacterBody2D

# Инициализируем анимированный спрайт и его поведение при повороте
@onready var animation = $AnimatedSprite2D
@onready var pl_flip_h = $AnimatedSprite2D
var show_btn = false
var block_movement = false

var path_going = true

# Константы для скорости и гравитации
const SPEED = 300.0
const GRAVITY = 1000.0

# Перечисление состояний движения персонажа
enum MOVE_STATE {IDLE_SIDE, IDLE_UP, IDLE_DOWN, MOVE_SIDE, MOVE_UP, MOVE_DOWN}

# Инициализация текущего состояния движения персонажа
@export var move_state = MOVE_STATE.IDLE_SIDE


func _physics_process(delta):
	if show_btn: 
		$CanvasLayer/Button.show()
	else: $CanvasLayer/Button.hide()
	# Получаем направление движения из пользовательского ввода
	var direction = Input.get_axis("ui_left", "ui_right") if !block_movement else 0.0
	
	# Устанавливаем горизонтальную скорость, если есть направление движения
	if direction:
		velocity.x = direction * SPEED
	else:
		# Иначе плавно останавливаем персонажа
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Для размещения персонажа используется упрощённая гравитация.
	velocity.y += GRAVITY
  
	# Определяем, нужно ли отразить спрайт по горизонтали, исходя из направления движения
	if velocity.x > 0:
		pl_flip_h.flip_h = false
	if velocity.x < 0:
		pl_flip_h.flip_h = true
	
	if path_going:
		if get_parent().progress_ratio > 0.0:
			set_anim(MOVE_STATE.MOVE_SIDE)
			$AnimatedSprite2D.set_speed_scale(0.77)
		if get_parent().progress_ratio == 1.0:
			path_going = false
			$AnimatedSprite2D.set_speed_scale(1.0)
		
		if get_parent().progress_ratio != 1.0:
			block_movement = true
		else: block_movement = false
  
	# Установка анимации в зависимости от того, двигается ли персонаж
	if !path_going:
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
			animation.animation = "idle_side"
		MOVE_STATE.MOVE_SIDE:
			animation.animation = "move_side"
