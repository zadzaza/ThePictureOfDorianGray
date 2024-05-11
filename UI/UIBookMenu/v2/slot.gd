extends Panel

var texture: Texture2D

@onready var icon_texture: Sprite2D = %IconTexture

func _ready():
	icon_texture.set_texture(texture)

func set_icon(texture_path: Texture2D):
	texture = texture_path
	icon_texture.set_texture(texture)

func is_using_slot() -> bool:
	return texture != null
