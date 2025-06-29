extends Control
class_name Glyph

signal s_create_new_char(ch)
signal s_remove_char(ch)

@export var CharLabel: Label
const glyph_tscn = preload("res://scenes/glyph.tscn")

const ROTATE_CENTER = Vector2(480, 240)
const ROTATE_R = 240

var _char: String
var _timer: float
#var _is_freezing: bool

var _tween: Tween

func get_char() -> String:
	return _char

func init(ch: String, yin_pos=Vector2(0,0)):
	#print("Glyph Init %s" % ch)
	_char = ch
	CharLabel.text = _char
	match ch:
		"活":
			self.position = Vector2(130,160)
		"字":
			self.position = Vector2(200,160+yin_pos.y)
		"词":
			self.position = Vector2(270,160+yin_pos.y)
		"句":
			self.position = Vector2(340,160+yin_pos.y)
		"文":
			self.position = Vector2(410,160)
		"印":
			init_yin(yin_pos)
		"刷":
			init_shua()
		"舟":
			init_zhou()
		"日","夜":
			init_day_night()
		"春","秋","夏","冬":
			init_season()
		"光":
			self.position = Vector2(500, 10)
		"月":
			self.position = Vector2(34, 22)
		"圆":
			self.position = Vector2(34, 122)
		"天":
			self.position = Vector2(570, 10)
		"山":
			self.position = Vector2(433, 86)
		"星":
			init_xing(yin_pos.y)
		"汉":
			init_han()
		"鸡":
			init_ji()
		"鸟":
			init_niao()
		"人":
			init_ren()
		"一","二","三","四","五","六","七","八","九":
			var arr = ["一","二","三","四","五","六","七","八","九"]
			var index = arr.find(ch)
			self.position = Vector2(200+64*index,220+yin_pos.y)
		"万":
			self.position = Vector2(200, 290)
		"长":
			self.position = Vector2(640, 280)
		"河":
			init_flow(Vector2(695, 325+yin_pos.y))
		"江":
			init_flow(Vector2(763, 423))
		"近":
			self.position = Vector2(390, 460)
		"远":
			init_yuan()
		"门":
			self.position = Vector2(350, 360)
		"推":
			init_tui()
		"敲":
			init_qiao()
		"声":
			init_sheng()
		"木":
			self.position = Vector2(30, 404+yin_pos.y)
		"林":
			self.position = Vector2(30, 340)
		"夕":
			self.position = Vector2(100, 270)
		"梦":	
			self.position = Vector2(180, 206)
		

func pause_tween():
	if _tween:
		_tween.pause()
		
func resume_tween():
	if _tween:
		_tween.play()
		
func init_sheng():
	self.position = Vector2(240, 226)
	_tween = create_tween()
	_tween.set_loops()
	var t = 0.5
	_tween.tween_property(self, "position", Vector2(220, 200), t)
	_tween.parallel().tween_property(self, "scale", Vector2(1.2, 1.2), t)
	_tween.parallel().tween_property(self, "modulate:a", 0.8, t)
	_tween.tween_interval(0.5)
	_tween.tween_property(self, "position", Vector2(240, 226), 0.01)
	_tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.01)
	_tween.parallel().tween_property(self, "modulate:a", 1, 0.01)

func init_yuan():
	self.position = Vector2(390, 460)
	_tween = create_tween()
	_tween.tween_property(self, "position", Vector2(640, 150), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.parallel().tween_property(self, "scale", Vector2(0.8,0.8), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func init_tui():
	self.position = Vector2(395, 390)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "position:x", 365, 0.4)
	_tween.tween_interval(0.5)
	_tween.tween_property(self, "position:x", 395, 0.3).set_trans(Tween.TRANS_LINEAR)
	_tween.tween_interval(0.5)
	
func init_qiao():
	self.position = Vector2(395, 330)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "position:x", 375, 0.2).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_interval(0.1)
	_tween.tween_property(self, "position:x", 395, 0.2).set_trans(Tween.TRANS_LINEAR)

func init_flow(pos):
	self.position = pos
	self.pivot_offset = Vector2(32,32)
	_tween = create_tween()
	_tween.set_loops()
	#_tween.set_parallel(true)
	_tween.tween_property(self, "position:y", pos.y+10, 0.3)
	_tween.parallel().tween_property(self, "rotation_degrees", 5, 0.3)
	_tween.tween_property(self, "position:y", pos.y-10, 0.3)
	_tween.parallel().tween_property(self, "rotation_degrees", -5, 0.3)
	#_tween.tween_property(self, "rotation_degrees", 10, 0.5)
	#_tween.set_parallel(false)

func init_ji():
	self.position = Vector2(220, 430)
	ji_jump()

func ji_jump():
	_tween = create_tween()
	_tween.tween_property(self, "position", Vector2(220+randi()%50-25, 430+randi()%50-25), 0.2)
	_tween.tween_interval(randf()*3)
	_tween.tween_callback(ji_jump)

func init_ren():
	self.position = Vector2(550, 380)
	ren_move()

func ren_move():
	_tween = create_tween()
	_tween.tween_property(self, "position", Vector2(550+randi()%100-50, 380+randi()%20-10), 0.5)
	_tween.tween_interval(randf()*3)
	_tween.tween_callback(ren_move)

func init_niao():
	self.position = Vector2(80, 130)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "position", Vector2(823, 207), 4)
	_tween.tween_property(self, "position", Vector2(80, 130), 4)
	return

func init_xing(y):
	self.position = Vector2(700, 20+y)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "modulate:a", 0.2, 0.4)
	_tween.tween_property(self, "modulate:a", 1, 0.4)

func init_han():
	self.position = Vector2(770, 20)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "modulate:a", 0.2, 0.6)
	_tween.tween_property(self, "modulate:a", 1, 0.6)

func init_zhou():
	self.position = Vector2(722, 293)
	self.modulate.a = 1
	_tween = create_tween()
	#_tween.set_loops()
	_tween.tween_property(self, "position", Vector2(667,342), 0.5)
	_tween.tween_property(self, "position", Vector2(780,429), 0.8)
	_tween.tween_property(self, "position", Vector2(738,488), 0.3)
	_tween.tween_property(self, "modulate:a", 0.01, 0.01)
	_tween.tween_interval(3)
	_tween.tween_callback(init_zhou)
	#_tween.tween_callback(finish)
	

func init_huo():
	self.position = Vector2(50, 230)
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(self, "rotation_degrees", -15, 0.45)
	_tween.tween_property(self, "rotation_degrees", 15, 0.45)

func init_yin(pos):
	self.position = pos
	_tween = create_tween()
	#_tween.set_loops()
	_tween.tween_property(self, "position:y", pos.y+110, 0.3).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_interval(0.3)
	_tween.tween_property(self, "position:y", pos.y, 1).set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(finish)

func finish():
	s_remove_char.emit(_char)
	self.queue_free()
	
func init_shua():
	self.position = Vector2(650-600, 80)
	_tween = create_tween()
	#_tween.set_loops()
	_tween.tween_property(self, "position:x", 850-600, 0.6).set_trans(Tween.TRANS_LINEAR)
	_tween.tween_interval(0.2)
	_tween.tween_property(self, "position:x", 650-600, 0.6).set_trans(Tween.TRANS_LINEAR)
	_tween.tween_interval(0.2)
	_tween.tween_callback(finish)

func init_season():
	self.position = Vector2(30, 30)
	_tween = create_tween()
	_tween.tween_property(self, "position:y", 400, 6)
	_tween.tween_callback(change_season)
	
func init_day_night():
	self.position = Vector2(40, 40)
	_tween = create_tween()
	_tween.tween_property(self, "position:x", 800, 6)
	_tween.tween_callback(change_day_night)

func change_season():
	s_remove_char.emit(_char)
	var arr = ["春","夏","秋","冬"]
	var i = arr.find(_char)
	s_create_new_char.emit(arr[(i+1)%4])
	self.queue_free()
	
func change_day_night():
	s_remove_char.emit(_char)
	if _char == "日":
		s_create_new_char.emit("夜")
	else:
		s_create_new_char.emit("日")
	self.queue_free()

static func new_glyph(ch: String, callback=null, remove_callback=null, yin_pos=Vector2(0,0)) -> Glyph:
	var gl:Glyph = glyph_tscn.instantiate()
	gl.init(ch,yin_pos)
	if callback:
		gl.s_create_new_char.connect(callback)
	if remove_callback:
		gl.s_remove_char.connect(remove_callback)
	return gl

func _get_drag_data(at_position):
	print("Pause Tween")
	if _tween:
		_tween.pause()
	var data = self
	var pre = Glyph.new_glyph(_char)
	pre.freeze()
	set_drag_preview(pre)
	self.modulate.a = 0.5
	return data

func freeze():
	if _tween:
		_tween.pause()
	
func stop_dragging(pos):
	print("Stop Dragging")
	if _tween:
		_tween.play()
	#_is_freezing = false
	self.position = pos
	self.modulate.a = 1
	
func _can_drop_data(at_position, data):
	return data is Glyph or data is GlyphButton
	
func _drop_data(at_position, data):
	print("DROPPED: %s" % data.get_char())
	var new_char = try_combine(data.get_char(), self.get_char())
	if new_char=="":
		# no new char
		if data is Glyph:
			data.stop_dragging(get_global_mouse_position())
			(data as Glyph).z_index = self.z_index+1
		else:
			s_create_new_char.emit(data.get_char())
	else:
		s_create_new_char.emit(new_char)
		if data is Glyph:
			data.finish()
		self.finish()

func try_combine(ch1, ch2) -> String:
	match ch1:
		"字":
			if ch2 == "字":
				return "词"
		"词":
			if ch2 == "词":
				return "句"
		"句":
			if ch2 == "句":
				return "文"
		"一","二","三","四","五","六","七","八","九":
			var arr = ["一","二","三","四","五","六","七","八","九"]
			if ch2 in arr:
				var i1 = arr.find(ch1)
				var i2 = arr.find(ch2)
				if i1 == i2:
					if i1 == 0:
						return "二"
					elif i1 == 1:
						return "三"
					elif i1 == 2:
						return "万"
				else:
					if i1 + 1 + i2+1 <10:
						return arr[i1+i2+1]
		
			
		"十":
			if ch2 == "十":
				return "百"
		"百":
			if ch2 == "百":
				return "千"
		"千":
			if ch2 == "千":
				return "万"
		"日"	:
			if ch2 == "日":
				return "月"
			if ch2 == "月":
				return "明"
		"月"	:
			if ch2 == "日":
				return "明"
		"星"	:
			if ch2 == "星":
				return "汉"
		"河":
			if ch2 == "河" or ch2 == "长":
				return "江"
		"长":
			if ch2 == "河":
				return "江"
		"鸡":
			if ch2 == "天":
				return "鸟"
		"天":
			if ch2 == "光":
				return "日"
			if ch2 == "鸡":
				return "鸟"
			if ch2 == "水":
				return "雨"
		"光":
			if ch2 =="天":
				return "日"
		"门":
			if ch2 == "敲":
				return "声"
		"推":
			match ch2:
				"近":
					return "远"
				"水":
					return "流"
		#"关":
			#if ch2 == "推":
				#return "开"
		"敲":
			match ch2:
				"门":
					return "声"
				"圆":
					return "破"
				"鸡","鸟":
					return "飞"
		"木":
			if ch2 == "木":
				return "林"
		"林":
			if ch2 == "夕":
				return "梦"
			if ch2 == "林":
				return "森"
		"夕":
			if ch2 == "林":
				return "梦"
		"人":
			match ch2:
				"夜":
					return "梦"
				"人":
					return "从"
				"长":
					return "高"
		"长":
			match ch2:
				"水":
					return "河"
				"人":
					return "高"
				"日":
					return "夏"
				"夜":
					return "冬"
				
	return ""
