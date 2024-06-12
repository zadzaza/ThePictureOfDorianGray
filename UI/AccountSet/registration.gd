extends Control

var login = ""
var password = ""
var current_date = ""
var is_signal_connected = false # Флаг для проверки однократности подключения сигнала

var is_entry_exist = true

func _ready():
	open()

func _on_close_pressed():
	close()

func _on_create_acc_pressed():
	login = $NinePatchRect/LoginTextEdit.get_text()
	password = $NinePatchRect/PasswordTextEdit.get_text()
	current_date = Time.get_date_string_from_system()

	login = DbManager.escape_string(login)
	password = DbManager.escape_string(password)

	if login != "" and password != "":
		var check_query = "SELECT * FROM users WHERE login = '{login}'".format({"login":login})
		DbManager.execute_query(check_query)
		DbManager.database.data_received.connect(_data_received)
		$NinePatchRect/CreateAcc.set_disabled(true)
		#$NinePatchRect/Close.set_disabled(true)
		await get_tree().create_timer(1.0).timeout
		
		if is_entry_exist == false:
			$NinePatchRect/CreateAcc.set_disabled(false)
			#$NinePatchRect/Close.set_disabled(false)
			var registr_done = load("res://UI/AccountSet/registr_done.tscn").instantiate()
			add_child(registr_done)
			var insert_query = "INSERT INTO users (login, password, registr_date) VALUES ('{login}', '{password}', '{registr_date}')".format({"login":login, "password":password, "registr_date":current_date})
			DbManager.execute_query(insert_query)
		else:
			$NinePatchRect/Close.set_disabled(false)
			$NinePatchRect/CreateAcc.set_disabled(false)
			var acc_exist = load("res://UI/AccountSet/acc_exist.tscn").instantiate()
			add_child(acc_exist)
	else:
		var registr_failed = load("res://UI/AccountSet/registr_failed.tscn").instantiate()
		add_child(registr_failed)

func _data_received(error_object: Dictionary, transaction_status: PostgreSQLClient.TransactionStatus, datas: Array) -> void:
	if self.name == "Registration":
		for data in datas:
			if data.command_tag == "SELECT 0":
				is_entry_exist = false
			else:
				is_entry_exist = true
		

func open() -> void:
	var tween = create_tween()
	
	tween.tween_property(
		self, 'scale', Vector2.ZERO, 0
	)
	tween.tween_property(
		self, 'scale', Vector2.ONE, .3
	).set_ease(
		Tween.EASE_OUT
	).set_trans(
		Tween.TRANS_BACK
	)

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
	queue_free()
