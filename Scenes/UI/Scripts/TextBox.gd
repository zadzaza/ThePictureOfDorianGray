extends MarginContainer


@onready var dialogue_label = $MarginContainer/DialogueLabel
@onready var timer = $LetterDisplayTimer


const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuatuion_time = 0.02

signal finished_displaying()

func _process(delta):
	set_pivot_offset(Vector2(0, 0))
	
func display_text(text_to_display: String):
	text = text_to_display
	dialogue_label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	dialogue_label.text = ""
	display_letter()

func display_letter():
	dialogue_label.text = text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuatuion_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout():
	display_letter()
