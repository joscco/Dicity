extends TextureRect

var active = false
var tween = Tween.new()

onready var diceRollScreen = get_parent()
func _ready():
	add_child(tween)

func _input(event):
	if active:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_global_rect().has_point(get_global_mouse_position()):
					SoundManager.playSound("plop")
					cancel()

func cancel():
	GameManager.currentAction = null
	diceRollScreen.currentActionSprite.delight()
	diceRollScreen.currentActionSprite = null
	diceRollScreen.toggleOverlay()
	
func highlight():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(0.9, 0.9), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	print("Delighting cancel button")
	tween.interpolate_property(self, 'rect_scale', null, Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

	
