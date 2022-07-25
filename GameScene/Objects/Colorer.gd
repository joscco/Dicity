extends TextureButton

export (String) var methodName

onready var diceRollScreen = get_parent().get_parent().get_parent()
var tween: Tween = Tween.new()

func _ready():
	add_child(tween)

func _pressed():
	if !GameManager.inTutorial:
			SoundManager.playSound("plop")
			toggleState()

func toggleState():
	if GameManager.currentAction == methodName:
		GameManager.currentAction = null
		diceRollScreen.currentActionSprite = null
		diceRollScreen.deactivateGameOverlay()
		delight()
	else:
		GameManager.currentAction = methodName
		GameManager.selectedDice = null
		diceRollScreen.changeHighlightedSprite(self)
		diceRollScreen.activateGameOverlay()

func highlight():
	
	tween.interpolate_property(self, 'rect_scale', null, Vector2(2, 2), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

