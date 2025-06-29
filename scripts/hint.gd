extends Control
class_name Hint

@export var label : Label
@export var bg: NinePatchRect

func init(text):
	label.text = text
	bg.size = Vector2(20 + len(text)*50, 80)
