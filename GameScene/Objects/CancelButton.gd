extends Sprite


onready var diceRollScreen = get_owner()

func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
					cancel()

func cancel():
	diceRollScreen.toggleOverlay()
	GameManager.currentAction = null
	diceRollScreen.currentActionSprite.delight()
	diceRollScreen.currentActionSprite = null
