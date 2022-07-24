extends Node

var boardState
var typeMap = ['Food','Fun','Education','Industry']
var offset = 10
var tileWidth = 100
var indexToSpriteDict = {}
var indexToTileDict = {}

var typeToSlotDict = {
	-1:load('res://Assets/Graphics/SlotSelection/notWorking.png'),
	0:load('res://Assets/Graphics/DiceGraphics/emptyField.png'),
	1:load('res://Assets/Graphics/SlotSelection/yellowSlot.png'),
	2:load('res://Assets/Graphics/SlotSelection/redSlot.png'),
	3:load('res://Assets/Graphics/SlotSelection/beigeSlot.png'),
	4:load('res://Assets/Graphics/SlotSelection/blackSlot.png')
}

export (PackedScene) var tile

onready var boardManager = BoardManager

func _ready():
	GameManager.setBoardRenderer(self)
	for i in range(-1,7):
		for j in range(4):
			indexToSpriteDict[[i,j]] = load(elementToSpritePath([i,j]))

func indexToScreenPos(row, column, totalRows, totalColumns):
	var val = Vector2(
		(row - (totalRows)/2.0) * (tileWidth + offset) + tileWidth/2,
		(column - (totalColumns)/2.0) * (tileWidth + offset) + tileWidth
	)
	return val

func elementToSpritePath(element):
	if element[0] == 0:
		return 'res://Assets/Graphics/DiceGraphics/emptyField.png'
	if element[0] == -1:
		return 'res://Assets/Graphics/DiceGraphics/blocker'+str(element[1]%2+1)+'.png'
	return 'res://Assets/Graphics/DiceGraphics/'+typeMap[element[1]]+'/dice'+str(element[0])+'.png'

func drawNewBoard():
	# Remove old tiles:
	for tile in indexToTileDict.values():
		tile.queue_free()

	# And draw the new ones
	print(BoardManager.boardState)
	var rows = BoardManager.boardState.size()
	var columns = BoardManager.boardState[0].size()
	
	for row in range(rows):
		for column in range(columns):
			var newTile = tile.instance()
			var newTexture = indexToSpriteDict[boardManager.boardState[row][column]]
			newTile.get_node('Sprite').texture = newTexture
			newTile.get_node('Sprite').offset = Vector2(-newTexture.get_width() / 2, -newTexture.get_height())
			newTile.position = indexToScreenPos(row, column, rows, columns)
			newTile.value = boardManager.boardState[row][column]
			newTile.index = [row,column]
			add_child(newTile)
			indexToTileDict[[row,column]] = newTile

func refreshBoardState():
	var rows = BoardManager.boardState.size()
	var columns = BoardManager.boardState[0].size()
	for row in range(rows):
		for column in range(columns):
			var tileToRefresh = indexToTileDict[[row,column]]
			
			tileToRefresh.multiplier = boardManager.indexToClusterSize(row,column)
			tileToRefresh.updateMultiplier()
			
			var newState = boardManager.boardState[row][column]
			
			tileToRefresh.value = newState
			if tileToRefresh.value[0] < 1 :
				tileToRefresh.tween.stop_all()
			
			var spriteToRefresh : Sprite = tileToRefresh.get_node('Sprite')
			var newTexture : StreamTexture = indexToSpriteDict[newState]
			spriteToRefresh.texture = newTexture
			spriteToRefresh.offset = Vector2(-newTexture.get_width() / 2, -newTexture.get_height())
