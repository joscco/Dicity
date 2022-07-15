extends Sprite


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				toggleState()
				
func toggleState():
	if GameManager.currentAction == 'changeNumber':
		GameManager.currentAction = null
	else:
		GameManager.currentAction = 'changeNumber'
