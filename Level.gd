extends Node2D

@onready var ui_book = preload("res://UI/UIBookMenu/v2/ui_book_menu.tscn")
@onready var foreground = get_tree().get_first_node_in_group("foreground")

@onready var point_portrait_room = %PointPortraitRoom.get_position()
@onready var point_library = %PointLibrary.get_position()
@onready var point_toilet = %PointToilet.get_position()

@onready var camera = %Camera2D

@onready var portrait_room_area = %PortraitRoomArea
@onready var library_area = %LibraryArea
@onready var toilet_area = %ToiletArea

var target_point: Vector2
var current_point = point_portrait_room

func _ready():
	portrait_room_area.body_entered.connect(_on_portrait_room_area_body_entered)
	library_area.body_entered.connect(_on_library_area_body_entered)
	toilet_area.body_entered.connect(_on_toilet_area_body_entered)

func _on_portrait_room_area_body_entered(body):
	target_point = point_portrait_room
	camera_transition(target_point)
	
func _on_library_area_body_entered(body):
	target_point = point_library
	camera_transition(target_point)
	
func _on_toilet_area_body_entered(body):
	target_point = point_toilet
	camera_transition(target_point)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var ui_book_instance = ui_book.instantiate()
		foreground.add_child(ui_book_instance)

func camera_transition(target_point: Vector2):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "position", target_point, 0.825).from(current_point)
	current_point = target_point
