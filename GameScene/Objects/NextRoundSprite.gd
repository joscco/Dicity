extends Sprite


onready var diceRollScreen = get_owner()


func _input(event):
	if visible:
		if GameManager.currentAction == null:
			if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
				if get_rect().has_point(get_local_mouse_position()):
						GameManager.nextRound()
						diceRollScreen.throwDice()
				
