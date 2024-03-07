extends CanvasLayer

var page = "page"
var count = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	$Slots/Slot1/TextureRect2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	switch_main_menu_buttons()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		count = 1
		hide()


func _on_continue_btn_pressed():
	hide()
	%PauseManager._resume()

func switch_main_menu_buttons():
	page = "page" + str(count)

	if page == "page1":
		%Page1.set_visible(true)
		%Page2.set_visible(false)
	if page == "page2":
		%Page1.set_visible(false)
		%Page2.set_visible(true)


func show_item(is_show_item: bool):
	if is_show_item:
		$Slots/Slot1/TextureRect2.show()
	else: $Slots/Slot1/TextureRect2.hide()


func put_in_slots():
	pass


func _on_save_btn_pressed():
	pass # Replace with function body.


func _on_load_btn_pressed():
	pass # Replace with function body.


func _on_exit_btn_pressed():
	get_tree().quit()


func _on_setting_btn_pressed():
	count += 1


func _on_back_btn_pressed():
	count -= 1
