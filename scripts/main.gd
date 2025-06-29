extends Node2D


@export var buttonContainer: GridContainer
@export var questionContainer: BoxContainer
@export var painting: TextureRect
@export var alllines: Array[OneLine]
@export var hint_panel: Control
@export var container: Control

const hint_tscn = preload("res://scenes/hint.tscn")

var _operating_glyphs: Array
var _glyph_instances: Array
var _known_characters: Array

var _finish_counter:int = 0 
var _hint_btn: GlyphButton
var _shua_btn: GlyphButton

var _day_night_tween: Tween
var _season_tween: Tween
var _day_night_glyph: Glyph
var _season_glyph: Glyph

var _is_alive: bool = false

func _ready():
	print("READY")
	
	painting.modulate = Color(0.6,0.6,0.6,1)
	painting.visible = false
	questionContainer.visible = false
		
	_operating_glyphs = []
	_known_characters = []
	_glyph_instances = []
	
	var text = "活字印刷"
	for i in len(text):
		var ch = text[i]
		#var g = Glyph.new_glyph(ch, create_new_glyph, remove_glyph)
		##g.position = Vector2(100+100*i, 200)
		#add_child(g)
		try_add_glyph_btn(ch)
	##Test
	#try_add_glyph_btn("近")
	#try_add_glyph_btn("推")
	#_finish_counter = 1
	add_one_question(_finish_counter)

func tween_season(ch):
	if _season_tween:
		_season_tween.kill()
	if _day_night_glyph:
		_day_night_tween.pause()
		_day_night_glyph.finish()
	_season_tween = create_tween()
	var color_spring = Color.from_rgba8(46, 230, 46, 255)
	var spring_start = Color.from_rgba8(46, 230, 138, 255)
	var color_summer = Color.from_rgba8(230, 46, 46, 255)
	var summer_start = Color.from_rgba8(138, 138, 46, 255)
	var color_autumn = Color.from_rgba8(230, 230, 46, 255)
	var autumn_start = Color.from_rgba8(230, 138, 46, 255)
	var color_winter = Color.from_rgba8(46, 230, 230, 255)
	var winter_start = Color.from_rgba8(46, 230, 138, 255)
	var t = 3
	match ch:
		"春":
			painting.modulate = spring_start
			_season_tween.tween_property(painting, "modulate", color_spring, t)
			_season_tween.tween_property(painting, "modulate", summer_start, t)
		"夏":
			painting.modulate = summer_start
			_season_tween.tween_property(painting, "modulate", color_summer, t)
			_season_tween.tween_property(painting, "modulate", autumn_start, t)
		"秋":
			painting.modulate = autumn_start
			_season_tween.tween_property(painting, "modulate", color_autumn, t)
			_season_tween.tween_property(painting, "modulate", winter_start, t)
		"冬":
			painting.modulate = winter_start
			_season_tween.tween_property(painting, "modulate", color_winter, t)
			_season_tween.tween_property(painting, "modulate", spring_start, t)
			

func day_night_alive(is_night:bool):
	if _day_night_tween:
		_day_night_tween.kill()
	if _season_glyph:
		_season_glyph.finish()
		_season_tween.pause()
	_day_night_tween = create_tween()
	#_day_night_tween.set_loops()
	if is_night:
		painting.modulate = Color(0.6,0.6,0.6,1)
		_day_night_tween.tween_property(painting, "modulate", Color(0.2, 0.2, 0.2, 1), 2)
		_day_night_tween.tween_interval(2)
		_day_night_tween.tween_property(painting, "modulate", Color(0.6, 0.6, 0.6, 1), 2)
		#_day_night_tween.tween_property(painting, "modulate", Color(1, 1, 1, 1), 3)
		#_day_night_tween.tween_property(painting, "modulate", Color(0.6, 0.6, 0.6, 1), 3)
	else:
		painting.modulate = Color(0.6,0.6,0.6,1)
		_day_night_tween.tween_property(painting, "modulate", Color(1, 1, 1, 1), 2)
		_day_night_tween.tween_interval(2)
		_day_night_tween.tween_property(painting, "modulate", Color(0.6, 0.6, 0.6, 1), 2)
		#_day_night_tween.tween_property(painting, "modulate", Color(0.2, 0.2, 0.2, 1), 3)
		#_day_night_tween.tween_property(painting, "modulate", Color(0.6, 0.6, 0.6, 1), 3)
	#painting.modulate
	#_day_night_tween.tween_property()

func add_one_question(index):
	if index >= len(alllines):
		#win
		play_win_animation()
		return
	var oneline = alllines[index]
	var q = Question.new_question(oneline.lid, oneline.texts, oneline.cells, on_finish_question)
	questionContainer.add_child(q)
	set_hint_button_efx(oneline.has_hint)

func play_win_animation():
	var gl = Glyph.new_glyph('梦')
	self.add_child(gl)
	gl.position = Vector2(588, 560)
	var tween = create_tween()
	var t = 2
	tween.tween_property($Background, "modulate", Color(0,0,0,1), t)
	tween.parallel().tween_property(gl, "scale", Vector2(4,4), t)
	tween.parallel().tween_property(gl, "position", Vector2(400, 200), t)
	tween.tween_interval(0.5)
	#var label = gl.CharLabel
	tween.tween_property(gl.CharLabel, "text", "终", 2)
		
func set_hint_button_efx(has_hint):
	_hint_btn.set_hint_efx(has_hint)
	
func try_add_glyph_btn(ch):
	if ch not in _known_characters:
		_known_characters.push_back(ch)
		var gb = GlyphButton.new_glyph(ch, press_glyph_button)
		buttonContainer.add_child(gb)	
		if ch == "印":
			_hint_btn = gb
		if ch == "刷":
			_shua_btn = gb
			gb.set_hint_efx(true)

func create_new_glyph(ch):
	#print("Create new glyph %s" % ch)
	if ch == "日" or ch=="夜":
		if _day_night_glyph:
			if ch == "日" and _day_night_glyph.get_char() == "日":
				create_new_glyph("月")
			_day_night_glyph.finish()
			_day_night_tween.kill()
			return
	if ch in ["春","秋","夏","冬"]:
		if _season_glyph:
			#if _season_glyph.get_char() == ch:
			_season_glyph.finish()
			_season_tween.kill()
			return
		
	if ch not in _operating_glyphs:
		_operating_glyphs.push_back(ch)
		var g: Glyph
		if ch == "印":
			var pos = alllines[_finish_counter].hint_pos
			g = Glyph.new_glyph(ch, create_new_glyph, remove_glyph, pos)
		else:
			g = Glyph.new_glyph(ch, create_new_glyph, remove_glyph)
		#g.position = position
		container.add_child(g)
		_glyph_instances.push_back(g)
		try_add_glyph_btn(ch)
		if ch == "日" or ch =="夜":
			_day_night_glyph = g
			day_night_alive(ch=="夜")
		if ch in ["春","秋","夏","冬"]:
			_season_glyph = g
			tween_season(ch)
	elif ch in ["一","二","三","字","句","词","河","星","木"]:
		var count = _operating_glyphs.count(ch)
		_operating_glyphs.push_back(ch)
		var g = Glyph.new_glyph(ch, create_new_glyph, remove_glyph, Vector2(0,32*count))
		#g.position = position
		container.add_child(g)
		_glyph_instances.push_back(g)
		
func remove_glyph(ch):
	
	if ch in _operating_glyphs:
		_operating_glyphs.erase(ch)
		
	match ch:
		"印":
			show_next_hint()
		"刷":
			show_painting()
		"日","夜":
			_day_night_glyph = null
		"春","夏","秋","冬":
			_season_glyph = null
			

func show_painting():
	painting.modulate.a = 0.1
	painting.visible = true
	questionContainer.modulate.a = 0.01
	questionContainer.visible = true
	var tween = create_tween()
	tween.tween_property(painting, "modulate:a", 1, 1)
	#tween.tween_callback(questionCont)
	tween.tween_property(questionContainer, "modulate:a", 1, 1)
	
func on_finish_question(id):
	print("Finish Quest ID %d" % id)
	var line = alllines[_finish_counter]
	for ch in line.unlocks:
		play_add_glyph_btn(ch)
		press_glyph_button(ch)
	_finish_counter+=1
	add_one_question(_finish_counter)

func play_add_glyph_btn(ch):
	var tween = create_tween()
	var gb = GlyphButton.new_glyph(ch)
	container.add_child(gb)
	gb.position = Vector2(610, 610)
	tween.tween_property(gb, "position", Vector2(1075, 265), 0.2)
	tween.tween_callback(gb.queue_free)
	tween.tween_callback(try_add_glyph_btn.bind(ch))
	#try_add_glyph_btn(ch)

func press_glyph_button(ch):
	match ch:
		"光":
			painting.modulate = Color(1,1,1,1)
		"刷":
			_shua_btn.set_hint_efx(false)
	
	create_new_glyph(ch)

func show_next_hint():
	var oneline = alllines[_finish_counter]
	if oneline.has_hint:
		var hint = hint_tscn.instantiate()
		hint.init(oneline.hint_text)
		hint_panel.add_child(hint)
		hint.position = oneline.hint_pos
		hint.rotation_degrees = oneline.hint_rotation
		show_hint(hint)
	_hint_btn.set_hint_efx(false)
	
func show_hint(label):
	label.modulate.a = 0.1
	label.visible = true
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1, 0.5)
	

func alive_all_glyph():
	for g in _glyph_instances:
		if g:
			if _is_alive:
				_day_night_tween.pause()
				g.pause_tween()
			else:
				_day_night_tween.play()
				g.resume_tween()
	_is_alive = !_is_alive
		
		
