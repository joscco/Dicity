extends Node2D

var currentAction = null
var selectedDice = null
var ghostSprite = null

var food = 0
var mood = 0
var education = 0
var industry = 0

var rollsLeft = 10

var diceCount = 2
var diceLeft = diceCount

var diceRerolls = 2
var diceRerollsLeft = diceRerolls

var typeChanges = 2
var typeChangesLeft = typeChanges

var gridWidth = 16
var gridHeight = 6
var mountainCount = 10

var moneyToEarn = 100
var foodNeeded = 100
var educationNeeded = 100
var funNeeded = 100


func _ready():
	ghostSprite = Sprite.new()
	ghostSprite.modulate.a = 0.5
	ghostSprite.z_index = 1
	add_child(ghostSprite)

func _process(delta):
	if selectedDice != null:
		ghostSprite.texture = selectedDice.get_node('DiceSprite').texture
		ghostSprite.position = get_local_mouse_position()

	else:
		ghostSprite.texture = null

func nextRound():
	rollsLeft -= 1
	getBoni()
	diceRerollsLeft = diceRerolls
	typeChangesLeft = typeChanges

func getBoni():
	var currentScore = BoardManager.getPointsForAllTypes()
	diceCount = int(currentScore[0]/20) + 2
	diceRerolls = int(currentScore[1]/20) + 2
	typeChanges = int(currentScore[2]/20) + 2
	
func updateStats():
	var currentScore = BoardManager.getPointsForAllTypes()
	food = currentScore[0]
	mood = currentScore[1]
	education = currentScore[2]
	industry = currentScore[3]

