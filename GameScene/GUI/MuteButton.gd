extends Sprite


var muted = false
onready var muteSprite = load('res://Assets/Graphics/UI/soundoff.png')
onready var soundSprite = load('res://Assets/Graphics/UI/soundOn.png')


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				toggleState()
				
func toggleState():
	muted = !muted
	
	if muted:
		texture = muteSprite
		SoundManager.stopMusic()
	else:
		texture = soundSprite
		SoundManager.playMusic()
