extends CanvasLayer

var time_to_fill: float  # Время, за которое ProgressBar должен заполниться
var elapsed_time = 0.0   # Время, прошедшее с начала загрузки

func _ready():
	$AnimationPlayer.play("light_up")
	randomize()
	time_to_fill = randf_range(0.02, 0.03)

func _process(delta):
	await get_tree().create_timer(randf_range(0, 2)).timeout
	elapsed_time += delta
	var progress = elapsed_time / time_to_fill
	$ProgressBar.value = min(progress, 100.0)
