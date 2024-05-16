extends Panel

var texture: Texture2D

@onready var icon_texture: Sprite2D = %IconTexture
@onready var hint = %Hint
@onready var area = %Area2D
@onready var items_hint = InventoryManager.get_items()

var current_name: String

func _ready():
	area.mouse_entered.connect(_on_slot_mouse_entered)
	area.mouse_exited.connect(_on_slot_mouse_exited)
	icon_texture.set_texture(texture)

func set_icon(texture_path: Texture2D):
	texture = texture_path
	icon_texture.set_texture(texture)

func is_using_slot() -> bool:
	return texture != null

func set_slot_name(item_name: String):
	current_name = item_name

func _on_slot_mouse_entered():
	if texture != null:
		hint.set_text(current_name)

func _on_slot_mouse_exited():
	if texture != null:
		hint.set_text("")
