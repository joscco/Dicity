extends TextureRect

onready var diceRollScreen = get_parent().get_parent().get_parent()
var active = true
var tween = Tween.new()

func _ready():
	add_child(tween)

func _input(event):
	if active:
		if not GameManager.showingDialogue:
			if GameManager.currentAction == null:
				if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
					if get_global_rect().has_point(get_global_mouse_position()):
							SoundManager.playSound("diceroll")
							wiggleSize()
							GameManager.nextRound()

func wiggleSize():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1.3, 1.3), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func highlight():
	# Put that thingy to the front
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(0, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
