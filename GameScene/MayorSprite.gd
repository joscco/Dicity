extends Sprite


onready var mayor = get_parent()
var tween
onready var tween_values = [Vector2(1,1), Vector2(0.98, 1.05)]

func _ready():
	tween = $Tween
	_start_tween()

func _input(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
					mayor.hint()
					

func _start_tween():
	tween.interpolate_property(self,'scale',tween_values[0], tween_values[1], 0.75, Tween.TRANS_BACK, Tween.EASE_OUT)    
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()
