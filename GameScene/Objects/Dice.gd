extends Area2D


# Declare member variables here. Examples:
var eyes 


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	eyes = randi() % 6 + 1
	var imgPathToLoad = 'res://Assets/Graphics/DiceGraphics/dice'+str(eyes)+'.png'
	$DiceSprite.texture = load(imgPathToLoad)



func _input_event(viewport, event, shape_idx):
	print('test')
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		print("Clicked")
