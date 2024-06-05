extends Control


func _ready():
	open()

func _on_close_pressed():
	close()
	
func _on_create_acc_pressed():
	print(self.name, " REGISTR")
	var login = $NinePatchRect/LoginTextEdit.get_text()
	var password = $NinePatchRect/PasswordTextEdit.get_text()
	var current_date = Time.get_date_string_from_system()
	
	login = DbManager.escape_string(login)
	password = DbManager.escape_string(password)
	
	if login != "" and password != "":
		var registr_done = load("res://UI/AccountSet/registr_done.tscn").instantiate()
		add_child(registr_done)
		var query = DbManager.execute_query("INSERT INTO users (login, password, registr_date) 
						VALUES ('{login}', '{password}', '{registr_date}')".format({"login":login, "password":password, "registr_date":current_date}))
	else:
		var registr_failed = load("res://UI/AccountSet/registr_failed.tscn").instantiate()
		add_child(registr_failed)

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
