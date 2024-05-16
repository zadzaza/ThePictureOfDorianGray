extends StaticBody2D

@onready var door_area = %DoorArea
@onready var door_knob = %DoorKnob
@onready var door = %Door
@onready var animated_sprite = %AnimatedSprite2D

var door_side_scale = Vector2(1.853, 0.951)
var door_scale = Vector2(1.0, 1.0)

enum DOOR_STATE {DOOR_SIDE, DOOR_UP, DOOR_DOWN}
@export var current_door_state: DOOR_STATE

func _ready():
	door_side_check()
	close_door()
	
	door_area.body_entered.connect(_on_door_area_body_entered)
	door_area.body_exited.connect(_on_door_area_body_exited)

func _on_door_area_body_entered(body):
	open_door()

func _on_door_area_body_exited(body):
	close_door()

func open_door():
	if door_knob != null and door != null:
		door_knob.hide()
		door.show()
	if animated_sprite != null:
		if current_door_state == DOOR_STATE.DOOR_UP:
			animated_sprite.play("door_up_opened")
		elif current_door_state == DOOR_STATE.DOOR_DOWN:
			animated_sprite.play("door_down_opened")

func close_door():
	if door_knob != null and door != null:
		door_knob.show()
		door.hide()
	if animated_sprite != null:
		if current_door_state == DOOR_STATE.DOOR_UP:
			animated_sprite.play("door_up_closed")
		elif current_door_state == DOOR_STATE.DOOR_DOWN:
			animated_sprite.play("door_down_closed")
		

func door_side_check():
	if current_door_state != DOOR_STATE.DOOR_SIDE:
		door_knob.queue_free()
		door.queue_free()
		$Doorway.queue_free()
	else: animated_sprite.queue_free()
