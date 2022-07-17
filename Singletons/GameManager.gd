extends Node2D

var currentAction = null
var selectedDice = null
var ghostSprite = null
var diceRollScreen

var level = 1
var food = 0
var fun = 0
var education = 0
var money = 0

var rollsLeft = 10

var diceCount = 5
var diceLeft = diceCount

var diceRerolls = 2
var diceRerollsLeft = diceRerolls

var typeChanges = 2
var typeChangesLeft = typeChanges

var gridWidth = 15
var gridHeight = 5
var mountainCount = 35

var foodNeeded = 100
var educationNeeded = 100
var funNeeded = 100

func _ready():
	ghostSprite = Sprite.new()
	ghostSprite.modulate.a = 0.5
	ghostSprite.z_index = 1
	add_child(ghostSprite)

func _process(_delta):
	if selectedDice != null:
		ghostSprite.texture = selectedDice.get_node('DiceSprite').texture
		## Make the ghost follow smoothly
		ghostSprite.position = get_local_mouse_position()
		ghostSprite.scale = lerp(ghostSprite.scale, Vector2(1,1), 0.3)
	else:
		if ghostSprite.scale == Vector2(0, 0):
			ghostSprite.texture = null
		else:
			ghostSprite.scale = lerp(ghostSprite.scale, Vector2(0, 0), 0.3)

func nextRound():
	rollsLeft -= 1
	getBoni()
	diceRerollsLeft = diceRerolls
	typeChangesLeft = typeChanges
	
func getMoneyNeededForThisLevel() -> int:
	return int(sqrt(level) * 30)

func getBoni():
	var currentScore = BoardManager.getPointsForAllTypes()
	diceCount = int(currentScore[0]/20) + 2
	diceRerolls = int(currentScore[1]/20) + 2
	typeChanges = int(currentScore[2]/20) + 2
	
func updateStats():
	var currentScore = BoardManager.getPointsForAllTypes()
	food = currentScore[0]
	fun = currentScore[1]
	education = currentScore[2]
	money = currentScore[3]
	
	if money >= getMoneyNeededForThisLevel():
		levelUp()

func levelUp():
	showLevelUpScreen()
	level += 1
	
func showLevelUpScreen():
	# Implement UI here
	pass
