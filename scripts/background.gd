extends Control

signal s_create_new_glyph(ch, pos)

func _ready():
	print("Bg ready")

func _can_drop_data(at_position, data):
	return data is Glyph or data is GlyphButton
	
func _drop_data(at_position, data):
	print("BG DROP")
	if at_position.y > 542:
		if data is Glyph:
			data.finish()
	else:
		if data is Glyph:
			data.stop_dragging(get_global_mouse_position())
		else:
			s_create_new_glyph.emit(data.get_char())
