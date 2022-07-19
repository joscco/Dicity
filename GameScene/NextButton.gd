extends Sprite

onready var mayor = get_parent().get_parent()
var scaleTween : Tween = Tween.new()

func _ready():
	add_child(scaleTween)
	
func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
					mayor.next()
					wiggleInSize()
					SoundManager.playSound('plop')
					
func wiggleInSize():
	scaleTween.interpolate_property(self, "scale", null, Vector2(1.1, 1.1), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	scaleTween.start()
	yield(scaleTween, "tween_completed")
	scaleTween.interpolate_property(self, "scale", null, Vector2(1, 1), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	scaleTween.start()
