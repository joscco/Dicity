extends TextureButton

onready var mayor = get_parent().get_parent()
var scaleTween : Tween = Tween.new()

func _ready():
	add_child(scaleTween)

func _pressed():
	SoundManager.playSound('plop')
	wiggleInSize()
	if GameManager.level == 0:
		GameManager.levelUp()
	mayor.closeTutorial()

func wiggleInSize():
	scaleTween.interpolate_property(self, "rect_scale", null, Vector2(1.3, 1.3), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
	scaleTween.start()
	yield(scaleTween, "tween_completed")
	scaleTween.interpolate_property(self, "rect_scale", null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN)
	scaleTween.start()
