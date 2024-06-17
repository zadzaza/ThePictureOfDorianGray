extends Control

var s: int = 0

func _ready():
	$AnimationPlayer.play("loading")

func _on_timer_timeout():
	s += 1
	if s >= 5:
		self.queue_free()
