extends Sprite

var tween = Tween.new()
var desiredAlpha = modulate

func _ready():
	add_child(tween)

func highlight():
	# Put that thingy to the front
	z_index = 1
	tween.interpolate_property(self, 'modulate', null, desiredAlpha, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	z_index = 0
	tween.interpolate_property(self, 'modulate', null, Color(1, 1, 1, 0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
