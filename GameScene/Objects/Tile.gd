extends Node2D

var tween : Tween
var value = [0, 0]
var index
var multiplier = 0
var tweening: bool

onready var sprite : Sprite = $Sprite
onready var selectionOverlay : Sprite = $Sprite/SelectionOverlay
onready var crossOverlay: Sprite = $Sprite/CrossOverlay
onready var bulldozeOverlay: Sprite = $Sprite/BulldozeOverlay

onready var tween_values = [Vector2(1,1), Vector2(0.98, 1.05)]
onready var boardRenderer = get_parent()

func _ready():
	tween = $Tween
	$NegativeImpact.hide()
	crossOverlay.hide()
	bulldozeOverlay.hide()
	selectionOverlay.hide()
	
	$Tween.connect("tween_completed", self, "retween")

func startTweening():
	tweening = true
	doTween()
	
func doTween():
	if tweening:
		tween.interpolate_property(self, 'scale', tween_values[0], tween_values[1], 0.75, Tween.TRANS_BACK, Tween.EASE_OUT)    
		tween.start()
	
func stopTweening():
	tween.interpolate_property(self, 'scale', null, Vector2(1, 1), 0.75, Tween.TRANS_BACK, Tween.EASE_OUT)    
	tween.start()
	tweening = false

func retween(_object, _key):
	if tweening:
		tween_values.invert()
		doTween()
		
func shrinkAway():
	tween.interpolate_property(self,'scale', null, Vector2(1.1, 0), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)    
	tween.start()
	
func growIn():
	tween.interpolate_property(self,'scale', null, Vector2(1, 1), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)    
	tween.start()
	
func highlight():
	crossOverlay.hide()
	bulldozeOverlay.hide()
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
			
	if GameManager.currentAction == "bulldoze" and value[0] > 0:
		selectionOverlay.show()
		bulldozeOverlay.show()
	
func delight():
	var tempTexture : StreamTexture = boardRenderer.indexToSpriteDict[value]
	$Sprite.texture = tempTexture
	$Sprite.offset = Vector2(-tempTexture.get_width()/2 , -tempTexture.get_height())
	selectionOverlay.hide()
	crossOverlay.hide()
	bulldozeOverlay.hide()

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
						value = [GameManager.selectedDice.eyes, GameManager.selectedDice.type]
						BoardManager.boardState[index[0]][index[1]] = value
						BoardManager.negativeImpact(index[0],index[1])
						$Sprite.texture = boardRenderer.indexToSpriteDict[value]
						GameManager.diceRollScreen.thrownDice.erase(GameManager.selectedDice)
						GameManager.selectedDice.vanish()
						GameManager.selectedDice = null
						GameManager.updateStats()
						GameManager.diceRollScreen.moveUpDice()
						boardRenderer.refreshBoardState()
						startTweening()
			elif GameManager.currentAction == "bulldoze":
				if value[0] > 0:
					SoundManager.playSound("plop")
					$DustParticles.emitting = true
					# Fun part: build a copy of the current tile, add it on top and fade it away
					var newTile = self.duplicate()
					get_parent().add_child(newTile)
					$Sprite.texture = boardRenderer.indexToSpriteDict[[0, 0]]
					$Sprite.offset = Vector2(-$Sprite.texture.get_width() / 2, -$Sprite.texture.get_height())
					newTile.shrinkAway()
					stopTweening()
					yield(newTile.tween, "tween_completed")
					# Once it's faded out, just act normally
					BoardManager.boardState[index[0]][index[1]] = [0, 0]
					GameManager.updateStats()
					boardRenderer.refreshBoardState()
					delight()
					
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
