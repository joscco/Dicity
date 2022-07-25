extends Node2D

var currentAction = null
var selectedDice = null
var ghostSprite = null
var diceRollScreen = null
var showingDialogue = false
var boardRenderer = null
var guiManager = null
var mayor = null

const maxGridWidth = 14
const maxGridHeight = 5
const maxMountainCount = 50

var level:int = 0
var inTutorial:bool = true
var inLevelUpMode:bool = false

enum GAME_OVER_REASON {
	NOT_ENOUGH_POINTS,
	NO_EDUCATION,
	NO_FOOD,
	NO_FUN
}
var reasonForGameOver:int

var warnings = {}

var food :int
var fun :int
var education:int
var money:int

var rollsLeft:int
var diceCount:int
var diceLeft:int
var numberChanges:int
var numberChangesLeft:int
var typeChanges:int
var typeChangesLeft:int

var gridWidth: int = 0
var gridHeight: int = 0
var mountainCount: int = 0 

func setBoardRenderer(renderer):
	BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
	boardRenderer = renderer
	
func setGUIManager(manager):
	guiManager = manager
	
func setMayor(newMayor):
	mayor = newMayor

func _ready():
	ghostSprite = Sprite.new()
	ghostSprite.modulate.a = 0.5
	ghostSprite.z_index = 1
	add_child(ghostSprite)

func _process(_delta):
	if selectedDice != null:
		ghostSprite.texture = selectedDice.get_node('DiceSprite').texture
		ghostSprite.position = get_local_mouse_position()
		ghostSprite.scale = lerp(ghostSprite.scale, Vector2(1,1), 0.3)
	else:
		if ghostSprite.scale == Vector2(0, 0):
			ghostSprite.texture = null
		else:
			ghostSprite.scale = lerp(ghostSprite.scale, Vector2(0, 0), 0.3)
			
	if level >= 1:
		showWarnings()
	
func showWarnings():
	if not warnings.empty():
		if (is_instance_valid(warnings['food']) 
			and is_instance_valid(warnings['mood']) 
			and is_instance_valid(warnings['education'])):
			if !inLevelUpMode and getFoodPercent() <= 25:
				warnings['food'].show()
			else:
				warnings['food'].hide()
			if !inLevelUpMode and getFunPercent() <= 25:
				warnings['mood'].show()
			else:
				warnings['mood'].hide()
			if !inLevelUpMode and getEducationPercent() <= 25:
				warnings['education'].show()
			else:
				warnings['education'].hide()
			
func startNewGame():
	level = 1
	
	gridWidth = 1
	gridHeight = 1
	mountainCount = 0
	
	resetTownStats()
	resetDiceStats()
	
	BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
	boardRenderer.drawNewBoard()
	diceRollScreen.throwDice()
	
func resetTownStats():
	food = 0
	fun = 0
	education = 0
	money = 0

func resetDiceStats():
	rollsLeft = 10
	diceCount = 5
	diceLeft = diceCount
	numberChanges = 2
	numberChangesLeft = numberChanges
	typeChanges = 2
	typeChangesLeft = typeChanges

func nextRound():
	rollsLeft -= 1
	
	var moneyNotReachedOnEndOfTime: bool = rollsLeft <= 0 and money < getMoneyNeededForThisLevel()
	var foodCrashed : bool = getFoodPercent() <= 0
	var funCrashed : bool = getFoodPercent() <= 0
	var educationCrashed : bool = getFoodPercent() <= 0
	
	if moneyNotReachedOnEndOfTime or foodCrashed or funCrashed or educationCrashed:
		if moneyNotReachedOnEndOfTime:
			reasonForGameOver = GAME_OVER_REASON.NOT_ENOUGH_POINTS
		elif foodCrashed:
			reasonForGameOver = GAME_OVER_REASON.NO_FOOD
		elif funCrashed: 
			reasonForGameOver = GAME_OVER_REASON.NO_FUN
		elif educationCrashed:
			reasonForGameOver = GAME_OVER_REASON.NO_EDUCATION
		TransitionManager.transitionTo("res://GameOverScene/GameOverScene.tscn")
	else:
		getBoni()
		numberChangesLeft = numberChanges
		typeChangesLeft = typeChanges
		diceLeft = diceCount
		diceRollScreen.throwDice()
	
func getMoneyNeededForThisLevel() -> int:
	if inTutorial:
		return [1, 5, 50, 39, 50, 69][mayor.tutorialLevel]
	return int(max(1, 5*level))

func getBoni():
	numberChanges = int(getFunPercent()/20) + 1
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
	if inTutorial:
		mayor.next()
	else:
		if level > 0:
			SoundManager.playSound("success")
			guiManager.on_level_up()
			inLevelUpMode = true
			yield(guiManager, "level_up_screen_done")
			inLevelUpMode = false
		
		# Update Stats and create new board
		level += 1
		
		resetTownStats()
		resetDiceStats()

		gridWidth = min(maxGridWidth, gridWidth + (level % 2) * 1)
		gridHeight = max(1, min(maxGridHeight, gridHeight + (1 - (level % 2)) * 1))
		if level > 2:
			mountainCount = clamp(mountainCount + 1, 0, min(maxMountainCount, gridHeight * gridWidth / 3))
		BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
		boardRenderer.drawNewBoard()
		diceRollScreen.throwDice()
	
func showTutorialLevel(tutLevel: int):
	resetTownStats()
	resetDiceStats()
	
	if tutLevel == 1:
		gridHeight = 1
		gridWidth = 1
		
		BoardManager.boardState = [[[0, 0]]]
		boardRenderer.drawNewBoard()
		diceRollScreen.setDice([[6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3]])
		
	elif tutLevel == 2:
		gridHeight = 2
		gridWidth = 2
		
		BoardManager.boardState = [
			[[6, 0], [-1, 0], [0, 0]], 
			[[6, 0], [-1, 0], [0, 0]], 
			[[6, 0], [-1, 0], [0, 0]]
		]
		GameManager.updateStats()
		boardRenderer.drawNewBoard()
		diceRollScreen.setDice([[6, 3], [6, 3], [6, 3], [6, 0]])
		
	elif tutLevel == 3:
		gridHeight = 2
		gridWidth = 4
		
		BoardManager.boardState = [
			[[6, 0], [6, 0], [0, 0]], 
			[[6, 0], [-1, 0], [0, 0]], 
			[[6, 0], [6, 0], [0, 0]]
		]
		GameManager.updateStats()
		boardRenderer.drawNewBoard()
		diceRollScreen.setDice([[6, 3], [6, 3], [6, 3], [6, 0]])
	
func getMoneyPercent():
	return 100.0 * money / getMoneyNeededForThisLevel()
	
func getEducationPercent():
	var educationNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 0.8
	return 50.0 + education - educationNeededForIndustry
	
func getFunPercent():
	var funNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 0.5
	return 50.0 + fun - funNeededForIndustry
	
func getFoodPercent():
	var foodNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 1.0
	return 50.0 + food - foodNeededForIndustry
