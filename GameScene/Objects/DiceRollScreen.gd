extends Node2D

export (PackedScene) var die

var currentActionSprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(GameManager.diceCount):
		var dieInstance = die.instance()
		add_child(dieInstance)
		dieInstance.position = $DiceAnchor.position + Vector2(i* 110,0)


func changeHighlightedSprite(newHighlight):
	if currentActionSprite != null:
		currentActionSprite.delight()
	currentActionSprite = newHighlight
	currentActionSprite.highlight()
	
	
