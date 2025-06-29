extends TextureRect
class_name Cell

signal s_fill_cell(ch)

const cell_tscn = preload("res://scenes/cell.tscn")

var _char:String

func init(ch):
	_char = ch
	
static func new_cell(ch, callback=null) -> Cell:
	var c = cell_tscn.instantiate()
	c.init(ch)	
	if callback:
		c.s_fill_cell.connect(callback)
	return c

func _can_drop_data(at_position, data):
	return data is Glyph or data is GlyphButton
	
func _drop_data(at_position, data): 
	print("Drop Cell %s" % data.get_char())
	
	if data is Glyph:
		if data.get_char() == _char:
			s_fill_cell.emit(data.get_char())
			var g = Glyph.new_glyph(_char)
			g.position = Vector2(0,0)
			g.modulate.a = 1
			g.freeze()
			self.add_child(g)
		data.finish()
	else:
		if data.get_char() == _char:	
			s_fill_cell.emit(data.get_char())
			var g = Glyph.new_glyph(_char)
			g.freeze()
			g.position = Vector2(0,0)
			self.add_child(g)
