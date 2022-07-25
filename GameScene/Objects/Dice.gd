extends Node2D

var eyes 
var type
var scaleTween : Tween
var moveTween : Tween
const moveSpeed = 100

var typeMap = ['Food','Fun','Education','Industry']

onready var diceRollScreen = get_parent()

func _ready():
	randomize()
	eyes = randi() % 6 + 1
	type = randi() % 4
	
	scaleTween = Tween.new()
	moveTween = Tween.new()
	
	add_child(scaleTween)
	add_child(moveTween)
	changeSprite()
	
func moveTo(newPosition: Vector2): 
	var distance = (newPosition - position).length()
	moveTween.interpolate_property(self, "position", null, newPosition, min(distance / moveSpeed, 0.8), Tween.TRANS_BACK, Tween.EASE_OUT)
	moveTween.start()

func changeSprite():
	var imgPathToLoad = 'res://Assets/Graphics/DiceGraphics/'+typeMap[type]+'/dice'+str(eyes)+'.png'
	var spriteTexture : StreamTexture = load(imgPathToLoad)
	$DiceSprite.texture = spriteTexture
	$DiceSprite.offset = Vector2(-spriteTexture.get_width() / 2, -spriteTexture.get_height())
	SoundManager.playSound('diceroll')

func reroll():
	if GameManager.numberChangesLeft > 0:
		eyes = randi() % 6 + 1
		changeSprite()
		GameManager.numberChangesLeft -= 1
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
		
func setType(newType):
	if type == newType:
			print('already of that type')
	else:
		type = newType
		changeSprite()
		
func setEyes(newEyes):
	if eyes == newEyes:
		print('already of that type')
	else:
		eyes = newEyes
		changeSprite()

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
	if not GameManager.showingDialogue:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if $DiceSprite.get_rect().has_point(get_local_mouse_position()):
				if event.pressed:
					SoundManager.playSound("plop")
					applyAction()

func highlight():
	scaleTween.interpolate_property(self,'scale',null,Vector2(1.3,1.3), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	scaleTween.start()

func delight():
	scaleTween.interpolate_property(self,'scale',null,Vector2(1,1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	scaleTween.start()

func toggleState():
	if diceRollScreen.currentActionSprite == self:
		diceRollScreen.currentActionSprite = null
		GameManager.selectedDice = null
		delight()
	else:
		diceRollScreen.changeHighlightedSprite(self)
		GameManager.selectedDice = self

func qFreeWith2Params(_object, _key):
	queue_free()

func vanish(decrease=true):
	GameManager.selectedDice = null
	GameManager.currentAction = null
	if decrease:
		GameManager.diceLeft -= 1
		if GameManager.diceLeft < 1:
			GameManager.nextRound()
	diceRollScreen.currentActionSprite = null
	scaleTween.interpolate_property(self, 'scale', null, Vector2(0,0), 0.3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	scaleTween.connect("tween_completed", self, 'qFreeWith2Params')
	scaleTween.start()

