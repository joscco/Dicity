extends Node

var boardState
var typeMap = ['Food','Fun','Education','Industry']
var offset = 10

export (PackedScene) var tile

onready var boardManager = get_owner()
# Called when the node enters the scene tree for the first time.
func _ready():
	boardState = boardManager.createDummyBoardState(5,10)
	drawboardState()

func indexToScreenPos(i,j):
	return $BoardAnchor.position + Vector2(i*(100+offset),j*(100+offset))

func elementToSpritePath(element):
	return 'res://Assets/Graphics/DiceGraphics/'+typeMap[element[1]]+'/dice'+str(element[0])+'.png'

func drawboardState():
	var rows = boardState.size()
	var columns = boardState[0].size()
	
	for row in range(rows):
		for column in range(columns):
			var newTile = tile.instance()
			newTile.get_node('Sprite').texture = load(elementToSpritePath(boardState[row][column]))
			newTile.position = indexToScreenPos(row, column)
			add_child(newTile)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

