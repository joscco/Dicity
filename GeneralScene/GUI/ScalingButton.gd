extends TextureButton

var moveTween = Tween.new()

func _ready():
	add_child(moveTween)
	connect("pressed", self, "on_pressed")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")

func on_pressed():
	pass
	
func on_mouse_entered():
	scaleTo(Vector2(1.2, 1.2))

func on_mouse_exited():
	scaleTo(Vector2(1, 1))

func scaleTo(scaleVector: Vector2):
	moveTween.stop_all()
	moveTween.interpolate_property(self, "rect_scale", null, scaleVector, 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	moveTween.start()

