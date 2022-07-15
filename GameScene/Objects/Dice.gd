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
	changeSprite()

func changeSprite():
	var imgPathToLoad = 'res://Assets/Graphics/DiceGraphics/'+typeMap[type]+'/dice'+str(eyes)+'.png'
	$DiceSprite.texture = load(imgPathToLoad)
	SoundManager.playSound('diceroll')
	

func reroll():
	if GameManager.diceRerollsLeft > 0:
		eyes = randi() % 6 + 1
		changeSprite()
		GameManager.diceRerollsLeft -= 1
	else:
		print('no more rerolls')
		SoundManager.playSound('error')

func changeType(newType):
	if GameManager.typeChangesLeft > 0:
		if type == newType:
			print('already of that type')
		else:
			type = newType
			changeSprite()
	else:
		print('no more typechanges')
		SoundManager.playSound('error')


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if $DiceSprite.get_rect().has_point(get_local_mouse_position()):
			if event.pressed:
				if GameManager.currentAction == 'changeColor':
					changeType(2)
				if GameManager.currentAction == 'changeNumber':
					reroll()
				GameManager.currentAction = null



