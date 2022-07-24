extends TextureButton

var muted = false
onready var muteSprite = load('res://Assets/Graphics/UI/soundoff.png')
onready var soundSprite = load('res://Assets/Graphics/UI/soundOn.png')

var tween = Tween.new()

func _ready():
	add_child(tween)

func _pressed():
	SoundManager.playSound("plop")
	wiggleSize()
	toggleState()
				
func wiggleSize():
	tween.interpolate_property(self, 'rect_scale', null, Vector2(0.75, 0.75), 0.05, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(self, 'rect_scale', null, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
				
func toggleState():
	muted = !muted
	
	if muted:
		texture_normal = muteSprite
		SoundManager.mute()
	else:
		texture_normal = soundSprite
		SoundManager.unmute()
