extends Sprite


onready var diceRollScreen = get_owner()
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				SoundManager.playSound("plop")
				toggleState()
				
func toggleState():
	diceRollScreen.toggleOverlay()
	if GameManager.currentAction == 'changeNumber':
		GameManager.currentAction = null
		delight()
	else:
		GameManager.currentAction = 'changeNumber'
		diceRollScreen.changeHighlightedSprite(self)


func highlight():
	tween.interpolate_property(self,'scale',null,Vector2(1.3,1.3),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self,'scale',null,Vector2(1,1),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
