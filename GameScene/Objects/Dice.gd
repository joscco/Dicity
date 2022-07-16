extends Node2D


# Declare member variables here. Examples:
var eyes 
var type
var tween

var typeMap = ['Food','Fun','Education','Industry']

onready var diceRollScreen = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	eyes = randi() % 6 + 1
	type = randi() % 4
	tween = Tween.new()
	add_child(tween)
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
			GameManager.typeChangesLeft -= 1
	else:
		print('no more typechanges')
		SoundManager.playSound('error')

func applyAction():
	if GameManager.currentAction == null:
		toggleState()
	elif GameManager.currentAction == 'changeNumber':
		reroll()
	elif GameManager.currentAction == 'changeStateToYellow':
		changeType(0)
	elif GameManager.currentAction == 'changeStateToRed':
		changeType(1)
	elif GameManager.currentAction == 'changeStateToBeige':
		changeType(2)
	elif GameManager.currentAction == 'changeStateToBlack':
		changeType(3)


func _input(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if $DiceSprite.get_rect().has_point(get_local_mouse_position()):
				if event.pressed:
					applyAction()

func highlight():
	tween.interpolate_property(self,'scale',null,Vector2(1.3,1.3),0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func delight():
	tween.interpolate_property(self,'scale',null,Vector2(1,1),0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


				
func toggleState():
	if diceRollScreen.currentActionSprite == $DiceSprite:
		delight()
	else:
		diceRollScreen.changeHighlightedSprite(self)
