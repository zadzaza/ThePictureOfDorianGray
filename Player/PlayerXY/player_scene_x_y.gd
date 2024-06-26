extends CharacterBody2D

# Инициализируем анимированный спрайт и его поведение при повороте
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation: String
@onready var frames_with_lamp = preload("res://Player/PlayerXY/with_lamp.tres")
@onready var frames_without_lamp = preload("res://Player/PlayerXY/without_lamp.tres")
@onready var pl_flip_h: bool

var show_btn = false
@export var pepe = true

var path_going = true

# Константы для скорости и гравитации
const SPEED = 230.0
const GRAVITY = 1000.0

# Перечисление состояний движения персонажа
enum MOVE_STATE {IDLE_DOWN, IDLE_UP, IDLE_SIDE, MOVE_SIDE, MOVE_UP, MOVE_DOWN}
# Инициализация текущего состояния движения персонажа
@export var move_state = MOVE_STATE.IDLE_DOWN
var current_state: MOVE_STATE


func _ready():
	drop_lamp()

func take_lamp():
	animated_sprite.set_sprite_frames(frames_with_lamp)
	$PointLight2D.visible = true
	
func drop_lamp():
	animated_sprite.set_sprite_frames(frames_without_lamp)
	$PointLight2D.visible = false

func _physics_process(delta):
	# Получаем направление движения из пользовательского ввода
	var direction = Input.get_vector("left", "right", "up", "down") if !Dialogic.VAR.block_movement else 0.0
	
	# Устанавливаем горизонтальную скорость, если есть направление движения
	if direction:
		velocity = direction * SPEED
	else:
		# Иначе плавно останавливаем персонажа
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Определяем, нужно ли отразить спрайт по горизонтали, исходя из направления движения
	if velocity.x > 0:
		pl_flip_h = false
	if velocity.x < 0:
		pl_flip_h = true
	
	$AnimatedSprite2D.flip_h = pl_flip_h
	
	#if path_going:
		#var parent = get_parent()
		#if parent != null:
			#if parent.progress_ratio > 0.0:
				#set_anim(MOVE_STATE.MOVE_SIDE)
				#$AnimatedSprite2D.set_speed_scale(0.77)
			#if parent.progress_ratio == 1.0:
				#path_going = false
				#$AnimatedSprite2D.set_speed_scale(1.0)
		#
			#if parent.progress_ratio != 1.0:
				#set_block_movement(true)
			#else:
				#set_block_movement(false)
		#else: pass
  
	# Установка анимации в условием того, что персонаж двигается
	#if !path_going and !Dialogic.VAR.block_movement:
	
	if velocity.x:
		current_state = MOVE_STATE.MOVE_SIDE
		
	if velocity.y > 0:
		current_state = MOVE_STATE.MOVE_DOWN
	elif velocity.y < 0:
		current_state = MOVE_STATE.MOVE_UP
	elif velocity == Vector2.ZERO:
		if move_state == MOVE_STATE.MOVE_SIDE:
			current_state = MOVE_STATE.IDLE_SIDE
		elif move_state == MOVE_STATE.MOVE_UP:
			current_state = MOVE_STATE.IDLE_UP
		elif move_state == MOVE_STATE.MOVE_DOWN:
			current_state = MOVE_STATE.IDLE_DOWN
	
	set_anim(current_state)
	animated_sprite.play(animation)
	
	# Перемещаем персонажа и выводим текущее состояние и позицию в консоль
	move_and_slide()

# Устанавливаем новое состояние анимации персонажа
func set_anim(new_state: MOVE_STATE):
	move_state = new_state
	
	# Выбираем анимацию на основе состояния персонажа
	match move_state:
		MOVE_STATE.IDLE_SIDE:
			animation = "idle_side"
		MOVE_STATE.MOVE_SIDE:
			animation = "move_side"
		MOVE_STATE.MOVE_UP:
			animation = "move_up"
		MOVE_STATE.IDLE_UP:
			animation = "idle_up"
		MOVE_STATE.MOVE_DOWN:
			animation = "move_down"
		MOVE_STATE.IDLE_DOWN:
			animation ="idle_down"
			
			
func set_block_movement(block: bool):
	Dialogic.VAR.block_movement = block

func set_btn_visible(btn_visible: bool, btn_animation: String):
	%Button.set_visible(btn_visible)
	%Button.set_animation(btn_animation)
