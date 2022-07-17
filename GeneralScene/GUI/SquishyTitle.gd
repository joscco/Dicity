extends Sprite

const speed = 0.1
const amplitudeX = 0.01
const amplitudeY = 0.03
var timer = 0
export (float) var offsetSquish = 0

func _process(delta):
	timer += 1
	scale = Vector2(1 + amplitudeX *sin(offsetSquish + timer * speed), 1 + amplitudeY * cos(offsetSquish + timer * speed))
