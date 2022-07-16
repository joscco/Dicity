extends Node

var dummyGameState = []

var boardState

func createMatrix(width, height):
	var matrix = []

	for row in range(height):
		matrix.append([])
		matrix[row].resize(width)

		for column in range(width):
			matrix[row][column] = 0 #row*width + column

	return matrix

func createDummyBoardState(width, height):
	randomize()
	var matrix = []

	for row in range(height):
		matrix.append([])
		matrix[row].resize(width)

		for column in range(width):
			matrix[row][column] = [randi()%7, randi() % 4]

	return matrix

func createEmptyBoardState(width, height, blocker = 0):
	randomize()
	var matrix = []

	for row in range(height):
		matrix.append([])
		matrix[row].resize(width)

		for column in range(width):
			matrix[row][column] = [0, 0]
	
	for _i in range(blocker):
		var blockerPos = [randi()%height, randi()%width]
		while matrix[blockerPos[0]][blockerPos[1]]==[-1,0]:
			blockerPos = [randi() % height, randi() % width]
		matrix[blockerPos[0]][blockerPos[1]]=[-1,0]
	
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


func getPossibleNeighborPositions(matrix, row, column):
	var possibleNeighbors = []
	var rows = matrix.size()
	var columns = matrix[0].size()
	if row > 0:
		possibleNeighbors.append([row-1,column])
	if row < rows -1:
		possibleNeighbors.append([row+1,column])
	if column > 0:
		possibleNeighbors.append([row,column-1])
	if column < columns -1:
		possibleNeighbors.append([row,column+1])
	return possibleNeighbors


func nonZeroNeighbors(matrix, row, column):
	var possibleNeighbors = getPossibleNeighborPositions(matrix, row, column)
	var nonZeroNeighbors = []
	for possibleNeighbor in possibleNeighbors:
		if matrix[possibleNeighbor[0]][possibleNeighbor[1]] != 0:
			nonZeroNeighbors.append(possibleNeighbor)
	return nonZeroNeighbors

func getOneConnectedComponent(matrix, row, column):
	var nonZeroNeighbors = nonZeroNeighbors(matrix,row,column)
	matrix[row][column]=0
	var conComp = [[row,column]]
	for nonZeroNeighbor in nonZeroNeighbors:
		conComp += getOneConnectedComponent(matrix, nonZeroNeighbor[0], nonZeroNeighbor[1])
	
	for compElement in conComp:
		matrix[compElement[0]][compElement[1]]=0
	return conComp
	
func getAllConnectedComponents(matrix):
	var rows = matrix.size()
	var columns = matrix[0].size()
	var components = []
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column]!= 0:
				var comp = getOneConnectedComponent(matrix, row, column)				
				components.append(comp)
	return components

func getPointsForOneType(matrix):
	var points = 0
	
	for i in range(1,7):
		var filter = filterByNumber(matrix,i)
		var comps = getAllConnectedComponents(filter)
		for comp in comps:
			points += i * comp.size() * comp.size()
	return points
	
func getPointsForAllTypes(matrix = boardState):
	var allPoints = [0,0,0,0]
	for i in range(4):
		allPoints[i] = getPointsForOneType(filterByType(matrix,i))
	return allPoints


func negativeImpact(i,j):
	
	var clusterType = boardState[i][j]
	var filteredByType = filterByType(boardState, clusterType[1])
	var filteredByNumber = filterByNumber(filteredByType, clusterType[0])
	var conComp = getOneConnectedComponent(filteredByNumber,i,j)
	
	if conComp.size() == 1:
		return
	else:
		var malus = min(conComp.size(), clusterType[0])
		for member in conComp:
			if member[0] >0:
				if boardState[member[0]-1][member[1]][0] > 0:
					if boardState[member[0]-1][member[1]][1]!=clusterType[1]:
						boardState[member[0]-1][member[1]][0] = max(0,boardState[member[0]-1][member[1]][0]-malus)
			if member[0]<GameManager.gridWidth-1:
				if boardState[member[0]+1][member[1]][0] > 0:
					if boardState[member[0]+1][member[1]][1]!=clusterType[1]:
						boardState[member[0]+1][member[1]][0] = max(0,boardState[member[0]+1][member[1]][0]-malus)
			if member[1]>0:
				if boardState[member[0]][member[1]-1][0] > 0:
					if boardState[member[0]][member[1]-1][1]!=clusterType[1]:
						boardState[member[0]][member[1]-1][0] = max(0,boardState[member[0]][member[1]-1][0]-malus)
			if member[1]<GameManager.gridHeight-1:
				if boardState[member[0]][member[1]+1][0] > 0:
					if boardState[member[0]][member[1]+1][1]!=clusterType[1]:
						boardState[member[0]][member[1]+1][0] = max(0,boardState[member[0]][member[1]+1][0]-malus)

