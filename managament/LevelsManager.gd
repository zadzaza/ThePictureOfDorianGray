extends Node


const NOT_HAS: String = "not_has"
const HAS: String = "has"
const DONE: String = "done"

var save_bird_count: int
var not_save_bird_count: int
var timeout_count: int

var ending = "not_complete"
var is_receive = true


func set_ending(end: int):
	is_receive = false
	ending = "good_end" if end == 1 else "bad_end"
	DbManager.execute_query("INSERT INTO choices (user_id, end_id) VALUES ({user_id}, {end_id})".format({"user_id":DbManager.current_id, "end_id":end}))

func get_ending():
	is_receive = true
	DbManager.execute_query("SELECT end_id FROM choices WHERE user_id = {user_id}".format({"user_id":DbManager.current_id}))
	DbManager.database.data_received.connect(_on_data_received)
	await get_tree().create_timer(1.5).timeout
	return ending

func reset_prolog():
	InventoryManager.inventory.clear()
	Dialogic.VAR.have_bird = false

func reset_house():
	InventoryManager.inventory.clear()
	
	Dialogic.VAR.bag_state = NOT_HAS
	Dialogic.VAR.coat_state = NOT_HAS
	Dialogic.VAR.corpse_state = NOT_HAS
	Dialogic.VAR.curtain_state = NOT_HAS
	Dialogic.VAR.knife_state = NOT_HAS
	Dialogic.VAR.lamp_state = NOT_HAS
	Dialogic.VAR.rag_state = NOT_HAS

func ep_complete():
	is_receive = true
	DbManager.execute_query("SELECT * FROM choices")
	await get_tree().create_timer(3.0).timeout
	DbManager.database.data_received.connect(_on_data_received)

func _on_data_received(error_object: Dictionary, transaction_status: PostgreSQLClient.TransactionStatus, datas: Array) -> void:
	if self.name == "LevelsManager" and is_receive == true:
		save_bird_count = 0
		not_save_bird_count = 0
		timeout_count = 0
		for data in datas:
			print(data.data_row, " data_row")
			if data.data_row.size() > 1:
				for i in range(0, data.data_row.size()):
					if data.data_row[i][2] == 1:
						save_bird_count += 1
					elif data.data_row[i][2] == 2:
						not_save_bird_count += 1
					elif data.data_row[i][2] == 3:
						timeout_count += 1
			elif data.data_row.size() == 1:
				if data.data_row[0][0] == 1:
					ending = "good_end"
				elif data.data_row[0][0] == 2:
					ending = "bad_end"
			elif data.data_row.size() == 0:
				ending = "not_complete"
