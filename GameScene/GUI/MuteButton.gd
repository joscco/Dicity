extends Sprite

var muted = false
onready var muteSprite = load('res://Assets/Graphics/UI/soundoff.png')
onready var soundSprite = load('res://Assets/Graphics/UI/soundOn.png')

var tween = Tween.new()

func _ready():
	add_child(tween)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				SoundManager.playSound("plop")
				wiggleSize()
				toggleState()
				
func wiggleSize():
	tween.interpolate_property(self, 'scale', null, Vector2(0.75, 0.75), 0.05, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(self, 'scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
				
func toggleState():
	muted = !muted
	
	if muted:
		texture = muteSprite
		SoundManager.mute()
	else:
		texture = soundSprite
		SoundManager.unmute()
