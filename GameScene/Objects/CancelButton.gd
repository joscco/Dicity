extends TextureButton

var active = false
var tween = Tween.new()

onready var diceRollScreen : DiceRollScreen = get_parent()
func _ready():
	add_child(tween)

func _pressed():
	if active:
		SoundManager.playSound("plop")
		cancel()

func cancel():
	GameManager.currentAction = null
	diceRollScreen.currentActionSprite.delight()
	diceRollScreen.currentActionSprite = null
	diceRollScreen.deactivateGameOverlay()
	diceRollScreen.deactivateBulldozerOverlay()
	
func highlight():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	print("Delighting cancel button")
	tween.interpolate_property(self, 'rect_scale', null, Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

	
