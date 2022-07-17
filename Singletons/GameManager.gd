extends Node2D

var currentAction = null
var selectedDice = null
var ghostSprite = null
var diceRollScreen
var showingDialogue = false
var level = 1

var warnings = {}

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

var gridWidth = 14
var gridHeight = 5
var mountainCount = 15
var maxMountainCount = 50

var boardRenderer = null
var guiManager = null

func setBoardRenderer(renderer):
	BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
	boardRenderer = renderer
	
func setGUIManager(manager):
	guiManager = manager

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
			
	if not warnings.empty():
		if is_instance_valid(warnings['food']) and is_instance_valid(warnings['mood']) and is_instance_valid(warnings['education']):
			if getFoodPercent() == 0:
				warnings['food'].show()
			else:
				warnings['food'].hide()
			if getFunPercent() == 0:
				warnings['mood'].show()
			else:
				warnings['mood'].hide()
			if getEducationPercent() == 0:
				warnings['education'].show()
			else:
				warnings['education'].hide()
			
func startNewGame():
	level = 1
	food = 0
	fun = 0
	education = 0
	money = 0

	rollsLeft = 10

	diceCount = 5
	diceLeft = diceCount

	diceRerolls = 2
	diceRerollsLeft = diceRerolls

	typeChanges = 2
	typeChangesLeft = typeChanges

	gridWidth = 15
	gridHeight = 5
	mountainCount = 30
	maxMountainCount = 70

func nextRound():
	rollsLeft -= 1
	
	var moneyNotReachedOnEndOfTime: bool = rollsLeft <= 0 and money < getMoneyNeededForThisLevel()
	var foodCrashed : bool = getFoodPercent() <= 0
	var funCrashed : bool = getFoodPercent() <= 0
	var educationCrashed : bool = getFoodPercent() <= 0
	
	if moneyNotReachedOnEndOfTime or foodCrashed or funCrashed or educationCrashed:
		TransitionManager.transitionTo("res://GameOverScene/GameOverScene.tscn")
	else:
		getBoni()
		diceRerollsLeft = diceRerolls
		typeChangesLeft = typeChanges
		diceLeft = diceCount
		diceRollScreen.throwDice()
	
func getMoneyNeededForThisLevel() -> int:
	return 65 + 10*level 

func getBoni():
	diceRerolls = int(getFunPercent()/20) + 1
	diceCount = int(getFoodPercent()/20) + 1
	typeChanges = int(getEducationPercent()/20) + 1
	
func updateStats():
	var currentScore = BoardManager.getPointsForAllTypes()
	food = currentScore[0]
	fun = currentScore[1]
	education = currentScore[2]
	money = currentScore[3]
	
	if money >= getMoneyNeededForThisLevel():
		levelUp()

func levelUp():
	# Give some Player feedback
	SoundManager.playSound("success")
	guiManager.on_level_up()
	yield(guiManager, "level_up_screen_done")
	
	# Update Stats and create new board
	level += 1
	rollsLeft = 10
	mountainCount = clamp(mountainCount + 5, 0, maxMountainCount)
	BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
	boardRenderer.refreshBoardState()
	updateStats()
	
func getMoneyPercent():
	return 100 * money / getMoneyNeededForThisLevel()
	
func getEducationPercent():
	var educationNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 3
	return clamp(50 + education - educationNeededForIndustry, 0, 100)
	
func getFunPercent():
	var funNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 2
	return clamp(50 + fun - funNeededForIndustry, 0, 100)
	
func getFoodPercent():
	var foodNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 4
	return clamp(50 + food - foodNeededForIndustry, 0, 100)
