extends TextureRect

var tween = Tween.new()
var desiredAlpha = modulate

func _ready():
	add_child(tween)

func highlight():
	tween.interpolate_property(self, 'modulate', null, desiredAlpha, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self, 'modulate', null, Color(1, 1, 1, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
