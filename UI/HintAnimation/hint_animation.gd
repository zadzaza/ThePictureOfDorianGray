extends Node2D

signal start_hint_animation(description, position)

@onready var floating_text = %FloatingText
@onready var animation_player = %AnimationPlayer

func _ready():
	self.start_hint_animation.connect(_on_start_hint_animation)
	
func _on_start_hint_animation(description: String, _position: Vector2):
	self.global_position = _position
	
	floating_text.set_text(description)
	
	animation_player.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	animation_player.play("fade_out")

func emit_start_hint_animation(description: String, _position: Vector2):
	start_hint_animation.emit(description, _position)
