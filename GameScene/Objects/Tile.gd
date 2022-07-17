extends Node2D


var tween
var value = [0,0]
var index
var multiplier = 0

onready var sprite : Sprite = $Sprite
onready var selectionOverlay : Sprite = $Sprite/SelectionOverlay
onready var crossOverlay: Sprite = $Sprite/CrossOverlay

onready var tween_values = [Vector2(1,1), Vector2(0.98, 1.05)]
onready var boardRenderer = get_parent()

func _ready():
	tween = $Tween
	$NegativeImpact.hide()
	crossOverlay.hide()
	selectionOverlay.hide()

func _start_tween():
	tween.interpolate_property(self,'scale',tween_values[0], tween_values[1], 0.75, Tween.TRANS_BACK, Tween.EASE_OUT)    
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()

func highlight():
	crossOverlay.hide()
	selectionOverlay.hide()

	if GameManager.selectedDice != null:
		selectionOverlay.show()
		selectionOverlay.texture = boardRenderer.typeToSlotDict[GameManager.selectedDice.type+1]
		if value[0] != 0:
			crossOverlay.show()
		else: 
			var tempTexture : StreamTexture = boardRenderer.typeToSlotDict[GameManager.selectedDice.type+1]
			$Sprite.texture = tempTexture
			$Sprite.offset = Vector2(-tempTexture.get_width()/2 , -tempTexture.get_height())
	
func delight():
	var tempTexture : StreamTexture = boardRenderer.indexToSpriteDict[value]
	$Sprite.texture = tempTexture
	$Sprite.offset = Vector2(-tempTexture.get_width()/2 , -tempTexture.get_height())
	selectionOverlay.hide()
	crossOverlay.hide()

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
						$DustParticles.emitting = true
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


func updateMultiplier():
	if multiplier > 1:
		$Sprite/Multiplier.text = 'x'+str(multiplier)
	else:
		$Sprite/Multiplier.text = ''


func showNegativeImpact(dmg):
	$NegativeImpact/NegativeImpactText.text = '-'+str(dmg)
	$NegativeImpact.reset()
	$NegativeImpact.show()
	$NegativeImpact.posTween.start()
	$NegativeImpact.alphaTween.start()
