extends Control


func _on_auth_button_pressed():
	pass # Replace with function body.


func _on_registr_button_pressed():
	var registtration = load("res://UI/AccountSet/registration.tscn").instantiate()
	add_child(registtration)
