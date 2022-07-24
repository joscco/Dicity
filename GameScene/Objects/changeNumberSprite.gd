extends TextureButton

onready var diceRollScreen = get_parent().get_parent()
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)

func _pressed():
	if not GameManager.showingDialogue:
			SoundManager.playSound("plop")
			toggleState()
				
func toggleState():
	if GameManager.currentAction == 'changeNumber':
		GameManager.currentAction = null
		delight()
		diceRollScreen.deactivateGameOverlay()
	else:
		GameManager.currentAction = 'changeNumber'
		diceRollScreen.changeHighlightedSprite(self)
		diceRollScreen.activateGameOverlay()


func highlight():
	tween.interpolate_property(self,'rect_scale',null,Vector2(1.3,1.3),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self,'rect_scale',null,Vector2(1,1),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
