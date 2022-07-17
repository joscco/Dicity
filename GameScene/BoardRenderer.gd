extends Node

var boardState
var typeMap = ['Food','Fun','Education','Industry']
var offset = 10
var indexToSpriteDict = {}
var indexToTileDict = {}

var typeToSlotDict = {-1:load('res://Assets/Graphics/SlotSelection/notWorking.png'),0:load('res://Assets/Graphics/DiceGraphics/emptyField.png'),1:load('res://Assets/Graphics/SlotSelection/yellowSlot.png'),2:load('res://Assets/Graphics/SlotSelection/redSlot.png'),3:load('res://Assets/Graphics/SlotSelection/beigeSlot.png'),4:load('res://Assets/Graphics/SlotSelection/blackSlot.png')}


export (PackedScene) var tile

onready var boardManager = BoardManager


func _ready():
	boardManager.boardState = boardManager.createEmptyBoardState(GameManager.gridHeight,GameManager.gridWidth,GameManager.mountainCount)
	for i in range(-1,7):
		for j in range(4):
			indexToSpriteDict[[i,j]] = load(elementToSpritePath([i,j]))


func indexToScreenPos(i,j):
	return $BoardAnchor.position + Vector2(i*(100+offset),j*(100+offset))

func screnPosToIndex(mousePosition):
	mousePosition -= $BoardAnchor.position
	var i = int(mousePosition[0]/(100+offset))
	var j = int(mousePosition[1]/(100+offset))
	return [i,j]

func elementToSpritePath(element):
	if element[0]==0:
		return 'res://Assets/Graphics/DiceGraphics/emptyField.png'
	if element[0]==-1:
		return 'res://Assets/Graphics/DiceGraphics/blocker'+str(element[1]%2+1)+'.png'
	return 'res://Assets/Graphics/DiceGraphics/'+typeMap[element[1]]+'/dice'+str(element[0])+'.png'

func drawboardState():
	var rows = BoardManager.boardState.size()
	var columns = BoardManager.boardState[0].size()
	
	for row in range(rows):
		for column in range(columns):
			var newTile = tile.instance()
			newTile.get_node('Sprite').texture = indexToSpriteDict[boardManager.boardState[row][column]]
			newTile.position = indexToScreenPos(row, column)
			newTile.value = boardManager.boardState[row][column]
			newTile.index = [row,column]
			add_child(newTile)
			indexToTileDict[[row,column]] = newTile


func refreshBoardState():
	var rows = BoardManager.boardState.size()
	var columns = BoardManager.boardState[0].size()
	for row in range(rows):
		for column in range(columns):
			indexToTileDict[[row,column]].get_node('Sprite').texture = indexToSpriteDict[boardManager.boardState[row][column]]
