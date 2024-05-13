extends Node2D

@onready var ui_book = preload("res://UI/UIBookMenu/v2/ui_book_menu.tscn")
@onready var ui_book_instance = ui_book.instantiate()

func _input(event):
	if event.is_action_pressed("ui_cancel") and has_node(ui_book_instance):
		add_child(ui_book_instance)
