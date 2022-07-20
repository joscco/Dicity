extends TextureRect

onready var diceRollScreen = get_parent().get_parent()
var tween

func _ready():
	tween = Tween.new()
	add_child(tween)

func _input(event):
	if not GameManager.showingDialogue:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_global_rect().has_point(get_global_mouse_position()):
				if event.pressed:
					SoundManager.playSound("plop")
					toggleState()
				
func toggleState():
	if GameManager.currentAction == 'bulldoze':
		GameManager.currentAction = null
		delight()
		#deactivateBulldozeOverlay()
	else:
		GameManager.currentAction = 'bulldoze'
		diceRollScreen.changeHighlightedSprite(self)
		#activateBulldozeOverlay()


func highlight():
	tween.interpolate_property(self,'rect_scale',null,Vector2(1.3,1.3),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self,'rect_scale',null,Vector2(1,1),0.3,Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
