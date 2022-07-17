extends Node2D


var tween
var value = [0,0]
var index

onready var tween_values = [Vector2(1,1), Vector2(1.1,1.1)]
onready var boardRenderer = get_parent()

func _ready():
	tween = $Tween

func _start_tween():
	tween.interpolate_property(self,'scale',tween_values[0],tween_values[1],2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)    
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()

func highlight():
	$Sprite.modulate = Color.blue
	
func  delight():
	$Sprite.modulate = Color.white
#Nils
func _input(event):
	if $Sprite.get_rect().has_point(get_local_mouse_position()):
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if GameManager.currentAction == null:
				if GameManager.selectedDice != null:
					if value[0] != 0:
						SoundManager.playSound('error')
						print('cant place on existing die') 
					else:
						SoundManager.playSound("plop")
						value = [GameManager.selectedDice.eyes,GameManager.selectedDice.type]
						BoardManager.boardState[index[0]][index[1]] = value
						BoardManager.negativeImpact(index[0],index[1])
						$Sprite.texture = boardRenderer.indexToSpriteDict[value]
						GameManager.diceRollScreen.thrownDice.erase(GameManager.selectedDice)
						GameManager.selectedDice.vanish()
						GameManager.selectedDice = null
						GameManager.updateStats()
						GameManager.diceRollScreen.moveUpDice()
						boardRenderer.refreshBoardState()
						_start_tween()
						
						

						
		else:
			highlight()
	else:
		delight()
