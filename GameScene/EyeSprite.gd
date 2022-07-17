extends Sprite


var blinking


func _process(_delta):
	if blinking:
		if randf() < 0.05:
			stopBlinking()	
	else:
		if randf() < 0.005:
			startBlinking()
			
func stopBlinking():
	blinking = false
	frame = 0
	
func startBlinking():
	blinking = true
	frame = 1
