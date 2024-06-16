extends CanvasLayer

signal time_is_up

@onready var time_left: int = 300
@onready var timer = $Timer

var time_going: bool
# Called when the node enters the scene tree for the first time.

func _ready():
	timer.one_shot = false
	timer.autostart = false
	timer.wait_time = 1.0
	
	timer.timeout.connect(_on_timer_timeout)
	start()

func _on_timer_timeout():
	if time_left != 0:
		time_left -= 1
		
		var minutes = time_left / 60
		var seconds = time_left % 60
		
		$MarginContainer/TimerLabel.text = "%02d:%02d" % [minutes, seconds]
	elif time_left <= 0:
		stop()
		time_is_up.emit()

func start():
	var tween = create_tween()
	tween.tween_property($MarginContainer/TimerLabel, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	await tween.finished
	
	timer.start()

func stop():
	$Timer.stop()
	
	var tween = create_tween()
	tween.tween_property($MarginContainer/TimerLabel, "modulate", Color(1, 1, 1, 0), 1.0).from(Color(1, 1, 1, 1))


func _on_button_pressed():
	stop()
	time_is_up.emit()
	$Button.queue_free()
