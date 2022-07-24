extends Control

var tween
export var type = ""
onready var tween_values = [Vector2(.5,.5), Vector2(1.2, 1.2)]

func _ready():
	tween = $Tween
	_start_tween()
	hide()
	GameManager.warnings[type]=self

func _start_tween():
	tween.interpolate_property(self,'rect_scale',tween_values[0], tween_values[1], 0.75, Tween.TRANS_BACK, Tween.EASE_OUT)    
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()
