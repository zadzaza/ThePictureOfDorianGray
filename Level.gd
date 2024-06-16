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
	
	start_open_dialog()
	
func start_open_dialog():
	Dialogic.VAR.block_movement = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(0, 0, 0, 1))
	
	await tween.finished
	Dialogic.start("open_dialog")

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


func _on_book_area_body_entered(body):
	$BookArea.set_monitoring(false)
	
	var comment = "''Эмали и камеи Готье'' в роскошном издании Шарпантье \nна японской бумаге с гравюрами Жакмара"
	var comment2 = "Книгу эту подарил мне Адриан Синглтон, \nхотя кому я это рассказываю?"
	var comment3 = "В любом случае, \nнужно будет прочесть на досуге"
	
	ItemsManager.start_hint_animation(comment, $BookArea.global_position)
	await get_tree().create_timer(4.5).timeout
	ItemsManager.start_hint_animation(comment2, $BookArea.global_position)
	await get_tree().create_timer(4.5).timeout
	ItemsManager.start_hint_animation(comment3, $BookArea.global_position)
	
	$BookArea.queue_free()

func _on_divan_area_body_entered(body):
	var comment = "В эту комнату никто не заходил уже лет 15. \nИдеальное место для портрета, который никто не должен видеть"
	ItemsManager.start_hint_animation(comment, $DivanArea.global_position)
	$DivanArea.queue_free()


func _on_chest_area_body_entered(body):
	var comment = "Этот сундук запирается на ключ. \nЯ мог бы спрятать сюда что-нибудь"
	ItemsManager.start_hint_animation(comment, $ChestArea.global_position)
	$ChestArea.queue_free()


func _on_fireplace_area_body_entered(body):
	var comment = "Газовый камин с асбестом, \nон может мне пригодиться..."
	ItemsManager.start_hint_animation(comment, $FireplaceArea.global_position)
	$FireplaceArea.queue_free()
