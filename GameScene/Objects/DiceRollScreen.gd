extends Node2D

export (PackedScene) var die

var currentActionSprite = null
var thrownDice = []
var overlayActive = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Overlay/OverlayBackground.delight()
	$Overlay/CancelButton.delight()
	throwDice()
	GameManager.diceRollScreen = self

func throwDice():
	for thrownDie in thrownDice:
		if is_instance_valid(thrownDie):
			thrownDie.vanish(false)
	GameManager.diceLeft = GameManager.diceCount
	for i in range(GameManager.diceCount):
		var dieInstance: Node2D = die.instance()
		add_child(dieInstance)
		thrownDice.append(dieInstance)
		dieInstance.position = $DiceAnchor.position + Vector2(i* 110, 0)

func moveUpDice():
	for i in range(thrownDice.size() - 1, -1, -1):
		if !is_instance_valid(thrownDice[i]):
			thrownDice.remove(i)

	var diceLeftInArray = thrownDice.size()
	for i in range(diceLeftInArray):
		thrownDice[i].moveTo($DiceAnchor.position + Vector2(i* 110, 0))

func changeHighlightedSprite(newHighlight):
	if currentActionSprite != null:
		currentActionSprite.delight()
	currentActionSprite = newHighlight
	currentActionSprite.highlight()
	
func toggleOverlay():
	if overlayActive:
		deactivateOverlay()
	else:
		activateOverlay()
	
func deactivateOverlay():
	overlayActive = false
	$NextRoundSprite.active = true
	$Overlay/CancelButton.active = false
	$NextRoundSprite.highlight()
	$Overlay/CancelButton.delight()
	$Overlay/OverlayBackground.delight()
	
func activateOverlay():
	overlayActive = true
	$NextRoundSprite.active = false
	$Overlay/CancelButton.active = true
	$NextRoundSprite.delight()
	$Overlay/CancelButton.highlight()
	$Overlay/OverlayBackground.highlight()
