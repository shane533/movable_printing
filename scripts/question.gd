extends Control
class_name Question

signal s_question_finished(id)

@export var label: Label

var _questionID:int
var _cells: Array
var _finish_count: int

const question_tscn = preload("res://scenes/question.tscn")

static func new_question(qid, line, cells, callback):
	var qs = question_tscn.instantiate()
	qs.init(qid, line, cells)
	if callback:
		qs.s_question_finished.connect(callback)
	return qs

func init(qid, line:String, cells):
	_questionID = qid
	_cells = cells
	for ch in cells:
		var i = line.find(ch)
		var cell = Cell.new_cell(ch, finish_cell)
		self.add_child(cell)
		var off = 0
		if i == 1:
			off = 5
		if i == 8:
			off = 10
		cell.position = Vector2(54*i+off, -5)
	
	for ch in cells:
		line = line.replace(ch, "    ")
		
	label.text = line

func finish_cell(ch):
	print("Finish One Cell")
	_finish_count += 1
	if _finish_count == len(_cells):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 1)
		tween.tween_callback(free_self)
		

func free_self():
	s_question_finished.emit(_questionID)
	self.queue_free()
