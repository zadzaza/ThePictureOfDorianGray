extends Area2D

# Укажите здесь путь до сцены объекта, который вы хотите спаунить
var spawn_scene = load("res://Scenes/Prologue/fly_bird.tscn")
#@onready var timer = $Timer

# Настройки таймера для спауна
var min_spawn_delay = 6.0
var max_spawn_delay = 6.0

func _ready():
	# Начать процесс спауна
	randomize() # инициализация генератора случайных чисел
	start_spawning()

func start_spawning():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = randf_range(min_spawn_delay, max_spawn_delay)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()
	await timer.timeout
	spawn_object()

func spawn_object():
	var instance = spawn_scene.instantiate()
	var x = randf_range(0, $CollisionShape2D.position.x)
	var y = randf_range(0, $CollisionShape2D.position.y)
	instance.position = Vector2(x, y)
	add_child(instance)
