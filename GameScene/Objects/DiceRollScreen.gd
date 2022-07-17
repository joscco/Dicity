extends Node2D

export (PackedScene) var die

var currentActionSprite = null
var thrownDice = []


# Called when the node enters the scene tree for the first time.
func _ready():
	$Overlay/OverlayBackground.delight()
	throwDice()
	GameManager.diceRollScreen = self

func throwDice():
	for thrownDie in thrownDice:
		if is_instance_valid(thrownDie):
			thrownDie.vanish()
	for i in range(GameManager.diceCount):
		var dieInstance: Node2D = die.instance()
		add_child(dieInstance)
		thrownDice.append(dieInstance)
		dieInstance.position = $DiceAnchor.position + Vector2(i* 110, 0)

func moveUpDice():
	for i in range(thrownDice.size() - 1, -1, -1):
		if !is_instance_valid(thrownDice[i]):
			thrownDice.remove(i)

	var diceLeft = thrownDice.size()
	for i in range(diceLeft):
		thrownDice[i].moveTo($DiceAnchor.position + Vector2(i* 110, 0))

func changeHighlightedSprite(newHighlight):
	if currentActionSprite != null:
		currentActionSprite.delight()
	currentActionSprite = newHighlight
	currentActionSprite.highlight()
	
func toggleOverlay():
	$NextRoundSprite.active = !$NextRoundSprite.active
	$Overlay/CancelButton.active = !$Overlay/CancelButton.active
	
	if $NextRoundSprite.active:
		$NextRoundSprite.highlight()
		$Overlay/CancelButton.delight()
		$Overlay/OverlayBackground.delight()
	else:
		$NextRoundSprite.delight()
		$Overlay/CancelButton.highlight()
		$Overlay/OverlayBackground.highlight()
	
	
