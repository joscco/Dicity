extends Node

var boardState
var typeMap = ['Food','Fun','Education','Industry']
var offset = 10
var indexToSpriteDict = {}
var indexToTileDict = {}

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
		return 'res://Assets/Graphics/DiceGraphics/blockerField.png'
	return 'res://Assets/Graphics/DiceGraphics/'+typeMap[element[1]]+'/dice'+str(element[0])+'.png'

func drawboardState():
	var rows = boardManager.boardState.size()
	var columns = boardManager.boardState[0].size()
	
	for row in range(rows):
		for column in range(columns):
			var newTile = tile.instance()
			newTile.get_node('Sprite').texture = indexToSpriteDict[boardManager.boardState[row][column]]
			newTile.position = indexToScreenPos(row, column)
			newTile.value = boardManager.boardState[row][column]
			newTile.index = [row,column]
			add_child(newTile)
			indexToTileDict[[row,column]] = newTile
