extends Node2D

export (PackedScene) var die

var currentActionSprite = null
var thrownDice = []

# Called when the node enters the scene tree for the first time.
func _ready():
	throwDice()
	

func throwDice():
	for thrownDie in thrownDice:
		thrownDie.vanish()
	for i in range(GameManager.diceCount):
		var dieInstance = die.instance()
		add_child(dieInstance)
		thrownDice.append(dieInstance)
		dieInstance.position = $DiceAnchor.position + Vector2(i* 110,0)

func changeHighlightedSprite(newHighlight):
	if currentActionSprite != null:
		currentActionSprite.delight()
	currentActionSprite = newHighlight
	currentActionSprite.highlight()
	
	
