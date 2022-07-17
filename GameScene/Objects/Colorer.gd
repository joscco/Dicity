extends Sprite

export (String) var methodName

onready var diceRollScreen = get_owner()
var tween: Tween = Tween.new()

func _ready():
	add_child(tween)

func _input(event):
	if not GameManager.showingDialogue:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
				SoundManager.playSound("plop")
				toggleState()

func toggleState():

	
	if GameManager.currentAction == methodName:
		GameManager.currentAction = null
		diceRollScreen.currentActionSprite = null
		diceRollScreen.deactivateOverlay()
		delight()
	else:
		GameManager.currentAction = methodName
		GameManager.selectedDice = null
		diceRollScreen.changeHighlightedSprite(self)
		diceRollScreen.activateOverlay()

func highlight():
	# Put that thingy to the front
	z_index = 1
	tween.interpolate_property(self, 'scale', null, Vector2(2, 2), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	z_index = 0
	tween.interpolate_property(self, 'scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

