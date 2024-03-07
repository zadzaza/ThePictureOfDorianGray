extends CanvasLayer

@export var p_selected = false
@export var i_selected = false
@export var s_selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%AnimationPlayer.play("appearance")

func _process(delta):
	if p_selected:
		%Peoples.set_texture_normal(load("res://Sprites/UI/UIBook/peoples_selected.png"))
	elif !p_selected:
		%Peoples.set_texture_normal(load("res://Sprites/UI/UIBook/peoples_none.png"))
	
	if i_selected:
		%Inv.set_texture_normal(load("res://Sprites/UI/UIBook/inv_selected.png"))
	elif !i_selected:
		%Inv.set_texture_normal(load("res://Sprites/UI/UIBook/inv_none.png"))
	
	if s_selected:
		%Settings.set_texture_normal(load("res://Sprites/UI/UIBook/settings_selected.png"))
	elif !s_selected:
		%Settings.set_texture_normal(load("res://Sprites/UI/UIBook/settings_none.png"))


func _on_animation_player_animation_finished(anim_name):
	%Book.set_animation("book_open")
	%Elements.set_visible(true)


func _on_peoples_pressed():
	p_selected = true
	i_selected = false
	s_selected = false
	
	%Page1.set_visible(true)
	%Page2.set_visible(false)

func _on_inv_pressed():
	i_selected = true
	p_selected = false
	s_selected = false
	
	%Page1.set_visible(false)
	%Page2.set_visible(true)


func _on_settings_pressed():
	s_selected = true
	i_selected = false
	p_selected = false
	
	%Page1.set_visible(false)
	%Page2.set_visible(false)

