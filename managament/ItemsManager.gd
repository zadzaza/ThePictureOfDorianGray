extends Node

const NOT_HAS: String = "not_has"
const HAS: String = "has"
const DONE: String = "done"

func set_has(item_name):
	# Тут мы проверяем наличие переменной в Dialogic.VAR перед изменением
	if Dialogic.VAR.has(item_name + "_state"):
		Dialogic.VAR[item_name + "_state"] = HAS

func set_done(item_name):
	# Точно такая же проверка, как в функции pick_item
	if Dialogic.VAR.has(item_name + "_state"):
		Dialogic.VAR[item_name + "_state"] = DONE
