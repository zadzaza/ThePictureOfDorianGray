extends CanvasLayer

var page = "page"
var count = 1

@onready var pause_manager = %PauseManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	switch_main_menu_buttons()


#func _input(event):
	#if event.is_action_pressed("escape"):
		#pause_manager._resume()
		#queue_free()

func _on_continue_btn_pressed():
	pause_manager._resume()
	queue_free()

func switch_main_menu_buttons():
	page = "page" + str(count)

	if page == "page1":
		%Page1.set_visible(true)
		%Page2.set_visible(false)
	if page == "page2":
		%Page1.set_visible(false)
		%Page2.set_visible(true)

func _on_save_btn_pressed():
	pass # Replace with function body.


func _on_load_btn_pressed():
	pass # Replace with function body.

func _on_exit_btn_pressed():
	pause_manager._resume()
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")

func _on_setting_btn_pressed():
	count += 1

func _on_back_btn_pressed():
	count -= 1
