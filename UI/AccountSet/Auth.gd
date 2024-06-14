extends Control


var query_result

var login
var password
var current_date

var is_user_exist = false

func _on_link_button_pressed():
	var registration = load("res://UI/AccountSet/registration.tscn").instantiate()
	add_child(registration)

func _on_login_btn_pressed():
	login = DbManager.escape_string($NinePatchRect/LoginTextEdit.get_text())
	password = DbManager.escape_string($NinePatchRect/PasswordTextEdit.get_text())
	current_date = Time.get_date_string_from_system()
	
	if login != "" and password != "":
		DbManager.execute_query("SELECT * FROM users WHERE login = '{login}' AND password = '{password}'".format({"login":login, "password":password}))
		DbManager.database.data_received.connect(_data_received)
		$NinePatchRect/LoginBtn.set_disabled(true)
		await get_tree().create_timer(1.0).timeout
		
		if is_user_exist == true:
			var auth_done = load("res://UI/AccountSet/auth_done.tscn").instantiate()
			add_child(auth_done)
		else:
			var auth_failed = load("res://UI/AccountSet/auth_failed.tscn").instantiate()
			add_child(auth_failed)
			$NinePatchRect/LoginBtn.set_disabled(false)
		
	else:
		var registr_failed = load("res://UI/AccountSet/registr_failed.tscn").instantiate()
		add_child(registr_failed)

func _data_received(error_object: Dictionary, transaction_status: PostgreSQLClient.TransactionStatus, datas: Array) -> void:
	print(self.name)
	if self.name == "Auth":
		for data in datas:
			if data.command_tag != "SELECT 0":
				is_user_exist = true
			else:
				is_user_exist = false

func close() -> void:
	var tween = create_tween()
	tween.tween_property(
		self, 'scale', Vector2.ONE, 0
	)
	tween.tween_property(
		self, 'scale', Vector2.ZERO, .3
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_BACK
	)
	
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")
