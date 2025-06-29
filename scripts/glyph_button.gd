extends TextureButton
class_name GlyphButton

signal s_glybutton_pressed(ch)

const glyph_btn_tscn = preload("res://scenes/glyph_button.tscn")
var _char:String
var _tween : Tween

func init(ch):
	_char = ch
	$Label.text = ch
	
func get_char() -> String:
	return _char

static func new_glyph(ch: String, callback=null) -> GlyphButton:
	var gl:GlyphButton = glyph_btn_tscn.instantiate()
	gl.init(ch)
	if callback:
		gl.s_glybutton_pressed.connect(callback)
	return gl	

func _on_pressed():
	s_glybutton_pressed.emit(_char)
	pass # Replace with function body.
	
func set_hint_efx(has_hint):
	if _tween:
		_tween.kill()
	if not has_hint:
		self.modulate.a = 1
	else:
		_tween = create_tween()
		_tween.set_loops()
		_tween.tween_property(self, "modulate:a", 0.2, 0.8)
		_tween.tween_property(self, "modulate:a", 1, 0.8)

func _get_drag_data(at_position):
	if _char == "印" or _char == "刷":
		return null
	var data = self
	var pre = Glyph.new_glyph(_char)
	pre.freeze()
	set_drag_preview(pre)
	return data
