extends TextureRect

var tween = Tween.new()
var active = false
var button
var desiredAlpha = modulate
var diceRollScreen

func _ready():
	add_child(tween)
	button = get_node("Button")
	diceRollScreen = get_parent()
	

func highlight():
	button.show()
	active = true
	tween.interpolate_property(self, 'modulate', null, desiredAlpha, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	button.hide()
	active = false
	tween.interpolate_property(self, 'modulate', null, Color(1,1,1,0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()


func _on_Button_pressed():
	if active:
		SoundManager.playSound("plop")
		cancel()




func cancel():
	GameManager.currentAction = null
	diceRollScreen.currentActionSprite.delight()
	diceRollScreen.currentActionSprite = null
	diceRollScreen.deactivateGameOverlay()
