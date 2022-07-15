extends Node2D


# Declare member variables here. Examples:
var eyes 
var type

var typeMap = ['Food','Fun','Education','Industry']

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	eyes = randi() % 6 + 1
	type = randi() % 4
	var imgPathToLoad = 'res://Assets/Graphics/DiceGraphics/'+typeMap[type]+'/dice'+str(eyes)+'.png'
	$DiceSprite.texture = load(imgPathToLoad)



func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if $DiceSprite.get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				if GameManager.diceRerollsLeft > 0:
					eyes = randi() % 6 + 1
					var imgPathToLoad = 'res://Assets/Graphics/DiceGraphics/'+typeMap[type]+'/dice'+str(eyes)+'.png'
					$DiceSprite.texture = load(imgPathToLoad)
					GameManager.diceRerollsLeft -= 1
				else:
					print('no more rerolls')


