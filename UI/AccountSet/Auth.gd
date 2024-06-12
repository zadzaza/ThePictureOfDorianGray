extends Control


var query_result

var login
var password
var current_date

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
	else:
		var registr_failed = load("res://UI/AccountSet/registr_failed.tscn").instantiate()
		add_child(registr_failed)

func _data_received(error_object: Dictionary, transaction_status: PostgreSQLClient.TransactionStatus, datas: Array) -> void:
	print(self.name)
	if self.name == "Auth":
		for data in datas:
			if data.data_row.size() > 0:
				var auth_done = load("res://UI/AccountSet/auth_done.tscn").instantiate()
				add_child(auth_done)
			else:
				var auth_failed = load("res://UI/AccountSet/auth_failed.tscn").instantiate()
				add_child(auth_failed)

		print(login, " login")
		print(password, " password")
