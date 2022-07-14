extends Sprite

onready var gunSprite: AnimatedSprite = $Gun
		
func adaptToGunRotation(rotation: float):
	# Rotation here is clockwise
	var absRotation = posmod(rotation, 360)
	
	if absRotation < 45:
		gunSprite.frame = 1
		gunSprite.scale.x = 1
		gunSprite.position.x = 20
	elif absRotation < 90:
		gunSprite.frame = 0
		gunSprite.scale.x = 1
		gunSprite.position.x = 20
	elif absRotation < 135:
		gunSprite.frame = 0
		gunSprite.scale.x = -1
		gunSprite.position.x = -20
	elif absRotation < 225:
		gunSprite.frame = 1
		gunSprite.scale.x = -1
		gunSprite.position.x = -20
	elif absRotation < 270:
		gunSprite.frame = 2
		gunSprite.scale.x = -1
		gunSprite.position.x = -20
	elif absRotation < 315:
		gunSprite.frame = 2
		gunSprite.scale.x = 1
		gunSprite.position.x = 20
	else:
		gunSprite.frame = 1
		gunSprite.scale.x = 1
		gunSprite.position.x = 20
		
