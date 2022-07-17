extends Sprite

var active = false
var tween = Tween.new()

onready var diceRollScreen = get_owner()

func _ready():
	add_child(tween)

func _input(event):
	if active:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(get_local_mouse_position()):
					cancel()

func cancel():
	GameManager.currentAction = null
	diceRollScreen.currentActionSprite.delight()
	diceRollScreen.currentActionSprite = null
	diceRollScreen.toggleOverlay()
	
func highlight():
	# Put that thingy to the front
	z_index = 1
	tween.interpolate_property(self, 'scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	z_index = 0
	tween.interpolate_property(self, 'scale', null, Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

	
