extends Node

var dummyGameState = []

var height = 5
var width = 10

func createMatrix(width, height):
	var matrix = []

	for row in range(height):
		matrix.append([])
		matrix[row].resize(width)

		for column in range(width):
			matrix[row][column] = 0#row*width + column

	return matrix

func createDummyBoardState(width, height):
	randomize()
	var matrix = []

	for row in range(height):
		matrix.append([])
		matrix[row].resize(width)

		for column in range(width):
			matrix[row][column] = [randi() % 7, randi() % 4]

	return matrix

func prettyPrint(matrix):
	for i in range(matrix.size()):
		print(matrix[i])
	

func filterByType(matrix,type):
	var rows = matrix.size()
	var columns = matrix[0].size()
	
	var output = createMatrix(columns,rows)
	
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column][1]==type:
				output[row][column] = matrix[row][column][0]
			else:
				output[row][column] = 0
	
	return output
			

func filterByNumber(matrix,number):
	var rows = matrix.size()
	var columns = matrix[0].size()
	
	var output = createMatrix(columns,rows)
	
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column]==number:
				output[row][column] = number
			else:
				output[row][column] = 0
	
	return output

func getConnectedComponents(matrix):
	pass

func _ready():
	var boardState = createDummyBoardState(width, height)
	var filteredForState1 = filterByType(boardState,1)
	var filteredForNumber3 = filterByNumber(filteredForState1,3)
	prettyPrint(boardState)
	print()
	prettyPrint(filteredForState1)
	print()
	prettyPrint(filteredForNumber3)
