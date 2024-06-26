extends Node2D

@onready var ui_book = preload("res://UI/UIBookMenu/v2/ui_book_menu.tscn")
@onready var timer = load("res://UI/Timer/timer.tscn").instantiate()

@onready var foreground = get_tree().get_first_node_in_group("foreground")

@onready var point_portrait_room = %PointPortraitRoom.get_position()
@onready var point_library = %PointLibrary.get_position()
@onready var point_toilet = %PointToilet.get_position()

@onready var camera = %Camera2D

@onready var portrait_room_area = %PortraitRoomArea
@onready var library_area = %LibraryArea
@onready var toilet_area = %ToiletArea

@onready var ending: String

var target_point: Vector2
var current_point = point_portrait_room

func _ready():
	portrait_room_area.body_entered.connect(_on_portrait_room_area_body_entered)
	library_area.body_entered.connect(_on_library_area_body_entered)
	toilet_area.body_entered.connect(_on_toilet_area_body_entered)
	Dialogic.signal_event.connect(_on_choice_selected)
	ItemsManager.all_items_done.connect(_on_all_items_done)
	timer.time_is_up.connect(_on_time_is_up)
	
	start_open_dialog()
	
	ending = LevelsManager.ending

func _on_all_items_done():
	timer.stop()
	if ending == "bad_end":
		Dialogic.VAR.block_movement = true
		Dialogic.start("bad_end_dialog")
		
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(0, 0, 0, 1.5), 1.0).from(Color(1, 1, 1, 1))
	if ending == "good_end":
		Dialogic.VAR.block_movement = true
		Dialogic.start("good_end_dialog")
		
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(0, 0, 0, 1.5), 1.0).from(Color(1, 1, 1, 1))

func start_open_dialog():
	Dialogic.VAR.block_movement = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(0, 0, 0, 1))
	
	await tween.finished
	Dialogic.start("open_dialog")

func _on_choice_selected(param: String):
	if param == "start_timer":
		add_child(timer)
		timer.start()
		
	if param == "timeout_end" or param == "bad_end":
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://UI/Titles/titles.tscn")
	elif param == "good_end":
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Levels/House/cutscene.tscn")

func _on_time_is_up():
	timer.stop()
	Dialogic.VAR.block_movement = true
	Dialogic.start("timeout_dialog")
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 1.5), 1.0).from(Color(1, 1, 1, 1))

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


func exclusive_hint():
	var comment = "''Эмали и камеи Готье'' в роскошном издании Шарпантье \nна японской бумаге с гравюрами Жакмара"
	var comment2 = "Книгу эту подарил мне Адриан Синглтон, \nхотя кому я это рассказываю?"
	var comment3 = "В любом случае, \nнужно будет прочесть на досуге"
	
	ItemsManager.start_hint_animation(comment, Vector2(1882, -87))
	await get_tree().create_timer(4.5).timeout
	ItemsManager.start_hint_animation(comment2, Vector2(1882, -87))
	await get_tree().create_timer(4.5).timeout
	ItemsManager.start_hint_animation(comment3, Vector2(1882, -87))

func _on_book_area_body_entered(body):
	exclusive_hint()
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
