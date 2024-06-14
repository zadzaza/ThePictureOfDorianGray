extends StaticBody2D


func _ready():
	bird_tweet()
	var timer = Timer.new()
	timer.wait_time = 5.0  # Задержка перед следующим вызовом в секундах.
	timer.timeout.connect(bird_tweet)
	add_child(timer)
	timer.start()

func bird_tweet():
	var tween = create_tween()
	var tweet_start = randf_range(0.0, 0.40)
	move_note()
	$AudioStreamPlayer2D.play(tweet_start)

func move_note():
	var tween = create_tween()

	var start_position = $MusicNote.position  # Начальная позиция MusicNote
	var end_position = Vector2(131, 53)    # Целевая позиция. Настройте это значение под вашу сцену

	# Интерполяция по оси X
	tween.tween_property($MusicNote, "position:x", end_position.x, 2.0).from(start_position.x).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	#Tween.TRANS_QUAD, Tween.EASE_OUT
	
	tween.tween_property($MusicNote, "position:y", end_position.y, 2.0).from(start_position.y).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
