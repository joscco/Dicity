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
var mountainCount = 30
var maxMountainCount = 70

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

func nextRound():
	rollsLeft -= 1
	getBoni()
	diceRerollsLeft = diceRerolls
	typeChangesLeft = typeChanges
	diceRollScreen.throwDice()
	
func getMoneyNeededForThisLevel() -> int:
	return int(sqrt(level) * 10)

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
	# Give some Player feedback
	SoundManager.playSound("success")
	guiManager.on_level_up()
	yield(guiManager, "level_up_screen_done")
	
	# Update Stats and create new board
	level += 1
	mountainCount = clamp(mountainCount + 5, 0, maxMountainCount)
	BoardManager.shuffleNewBoard(gridHeight, gridWidth, mountainCount)
	boardRenderer.refreshBoardState()
	updateStats()
	
func getMoneyPercent():
	return 100 * money / getMoneyNeededForThisLevel()
	
func getEducationPercent():
	var educationNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 3
	if educationNeededForIndustry == 0:
		return 50
	else:
		return clamp(50 + education - educationNeededForIndustry, 0, 100)
	
func getFunPercent():
	var funNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 2
	if funNeededForIndustry == 0:
		return 50
	else:
		return clamp(50 + fun - funNeededForIndustry, 0, 100)
	
func getFoodPercent():
	var foodNeededForIndustry = BoardManager.getIndustryPointsWithoutClusters() * 4
	if foodNeededForIndustry == 0:
		return 50
	else:
		return clamp(50 + food - foodNeededForIndustry, 0, 100)
