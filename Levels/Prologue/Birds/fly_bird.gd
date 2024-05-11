extends CharacterBody2D

@onready var speed = randf_range(50000, 60000)

func _ready():
	randomize()
	
func _physics_process(delta):
	velocity.x = speed * delta
	move_and_slide()
