extends CanvasLayer

var z_p_selected = false
var z_i_selected = false
var z_s_selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%AnimationPlayer.play("appearance")
	
func _process(delta):
	if z_p_selected:
		%ZakladkaPeoples.set_animation("selected")
		z_i_selected = false
		z_s_selected = false
	elif z_i_selected:
		%ZakladkaInv.set_animation("selected")
		z_p_selected = false
		z_s_selected = false
	elif z_s_selected:
		%ZakladkaSettings.set_animation("selected")
		z_i_selected = false
		z_p_selected = false
	
	if !z_p_selected:
		%ZakladkaPeoples.set_animation("none")
	if !z_i_selected:
		%ZakladkaInv.set_animation("none")
	if !z_s_selected:
		%ZakladkaSettings.set_animation("none")

func _on_animation_player_animation_finished(anim_name):
	%Book.set_animation("book_open")
	%Zakladki.set_visible(true)


func _on_zakladka_peoples_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			z_p_selected = true
			print("z_p_selected ", z_p_selected)
			print("z_i_selected ", z_i_selected)
			print("z_s_selected ", z_s_selected)

func _on_zakladka_inv_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			z_i_selected = true
			print("z_i_selected ", z_i_selected)
			print("z_p_selected ", z_p_selected)
			print("z_s_selected ",z_s_selected)

func _on_zakladka_settings_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			z_s_selected = true
			print("z_s_selected ",z_s_selected)
			print("z_p_selected ", z_p_selected)
			print("z_i_selected ", z_i_selected)
