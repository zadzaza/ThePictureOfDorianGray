extends CanvasLayer

var time_to_fill: float  # Время, за которое ProgressBar должен заполниться
var elapsed_time = 0.0   # Время, прошедшее с начала загрузки

func _ready():
	$AnimationPlayer.play("light_up")
	randomize()
	time_to_fill = randf_range(0.02, 0.05)

func _process(delta):
	await get_tree().create_timer(randf_range(0.5, 2)).timeout
	elapsed_time += delta
	var progress = elapsed_time / time_to_fill
	$ProgressBar.value = min(progress, 100.0)


func _on_progress_bar_value_changed(value):
	if value == 100:
		$AnimationPlayer.play('dissolve')
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://Scenes/Prologue/prologue_scene.tscn")
