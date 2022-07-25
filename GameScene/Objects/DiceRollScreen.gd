extends Control
class_name DiceRollScreen

export (PackedScene) var die

var currentActionSprite = null
var thrownDice = []
var overlayActive = false
var bulldozerOverlayActive = false

onready var gameOverlay : TextureRect = $DiceOverlay
onready var bulldozerOverlay : TextureRect = $BulldozerOverlay
onready var cancelButton : TextureButton = $CancelButton
onready var slotsBackground: TextureRect = $SlotsBackground
onready var diceAnchor : TextureRect = $SlotsBackground/DiceAnchor

onready var nextRoundButton: TextureButton = $Buttons/NextRoundButton
onready var bulldozerButton : TextureButton = $Buttons/BulldozerButton
onready var numberChangeButton : TextureButton = $Buttons/ChangeNumberSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	bulldozerOverlay.delight()
	gameOverlay.delight()
	cancelButton.delight()
	
	diceAnchor.hide()
	throwDice()
	GameManager.diceRollScreen = self
	
func setDice(arr):
	for thrownDie in thrownDice:
		if is_instance_valid(thrownDie):
			thrownDie.vanish(false)
	
	GameManager.diceLeft = arr.size()
	for i in range(arr.size()):
		var dieInstance: Node2D = die.instance()
		slotsBackground.add_child(dieInstance)
		thrownDice.append(dieInstance)
		dieInstance.setType(arr[i][1])
		dieInstance.setEyes(arr[i][0])
		dieInstance.position = diceAnchor.get_rect().position + Vector2(50 + i* 110, 100)

func throwDice():
	for thrownDie in thrownDice:
		if is_instance_valid(thrownDie):
			thrownDie.vanish(false)
	GameManager.diceLeft = GameManager.diceCount
	for i in range(GameManager.diceCount):
		var dieInstance: Node2D = die.instance()
		slotsBackground.add_child(dieInstance)
		thrownDice.append(dieInstance)
		dieInstance.position = diceAnchor.get_rect().position + Vector2(50 + i* 110, 100)

func cleanDiceCache():
	for i in range(thrownDice.size() - 1, -1, -1):
		if !is_instance_valid(thrownDice[i]):
			thrownDice.remove(i)
	
func moveUpDice():
	cleanDiceCache()
	var diceLeftInArray = thrownDice.size()
	for i in range(diceLeftInArray):
		thrownDice[i].moveTo(diceAnchor.get_rect().position + Vector2(50 + i* 110, 100))

func changeHighlightedSprite(newHighlight):
	if currentActionSprite != null:
		currentActionSprite.delight()
	currentActionSprite = newHighlight
	currentActionSprite.highlight()
	
func toggleOverlay():
	if overlayActive:
		deactivateGameOverlay()
	else:
		activateGameOverlay()
		
func toggleBulldozerOverlay():
	if bulldozerOverlayActive:
		deactivateBulldozerOverlay()
	else:
		activateBulldozerOverlay()
		
func activateBulldozerOverlay():
	bulldozerOverlayActive = true
	nextRoundButton.active = false
	cancelButton.active = true
	nextRoundButton.delight()
	cancelButton.highlight()
	bulldozerOverlay.highlight()
	
func deactivateBulldozerOverlay():
	bulldozerOverlayActive = false
	nextRoundButton.active = true
	cancelButton.active = false
	nextRoundButton.highlight()
	cancelButton.delight()
	bulldozerOverlay.delight()
	
func deactivateGameOverlay():
	overlayActive = false
	nextRoundButton.active = true
	cancelButton.active = false
	nextRoundButton.highlight()
	cancelButton.delight()
	gameOverlay.delight()
	
func activateGameOverlay():
	overlayActive = true
	nextRoundButton.active = false
	cancelButton.active = true
	nextRoundButton.delight()
	cancelButton.highlight()
	gameOverlay.highlight()
