extends Sprite

onready var mayor = get_parent()

func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
					SoundManager.playSound('plop')
					mayor.tutorialOver = true
					mayor.next()
