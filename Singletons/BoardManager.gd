extends Node

var dummyGameState = []

# Remember: 0 = Food, 1 = Fun, 2 = Education, 3 = Industry
const TYPE = {
	FOOD = 0,
	FUN = 1,
	EDUCATION = 2,
	INDUSTRY = 3
}

var boardState

func shuffleNewBoard(height: int, width: int, blockers: int = 0):
	boardState = createEmptyBoardState(height, width, blockers)

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

func createEmptyBoardState(width: int, height: int, blocker: int = 0):
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
		matrix[blockerPos[0]][blockerPos[1]]=[-1,randi()%2]
	
	return matrix

func prettyPrint(matrix):
	for i in range(matrix.size()):
		print(matrix[i])
	
# Returns 2D Array
func createFilterByTypeCopy(matrix,type) :
	var rows = matrix.size()
	var columns = matrix[0].size()
	
	var output = createMatrix(columns,rows)
	
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column][1] == type:
				output[row][column] = matrix[row][column][0]
			else:
				output[row][column] = 0
	return output
			

func createFilterByNumberCopy(matrix,number):
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
		possibleNeighbors.append([row - 1, column])
	if row < rows - 1:
		possibleNeighbors.append([row + 1, column])
	if column > 0:
		possibleNeighbors.append([row, column - 1])
	if column < columns - 1:
		possibleNeighbors.append([row, column + 1])
	return possibleNeighbors


func nonZeroNeighbors(matrix, row, column):
	var possibleNeighbors = getPossibleNeighborPositions(matrix, row, column)
	var nonZeroNeighbors = []
	for possibleNeighbor in possibleNeighbors:
		if matrix[possibleNeighbor[0]][possibleNeighbor[1]] != 0:
			nonZeroNeighbors.append(possibleNeighbor)
	return nonZeroNeighbors

func getOneConnectedComponent(matrix, row, column):
	matrix[row][column] = 0
	
	var nonZeroNeighbors = nonZeroNeighbors(matrix, row, column)
	var conComp = [[row, column]]
	for nonZeroNeighbor in nonZeroNeighbors:
		var neighborComp= getOneConnectedComponent(matrix, nonZeroNeighbor[0], nonZeroNeighbor[1])
		for compElement in neighborComp:
			if !conComp.has(compElement):
				conComp.append(compElement)
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
		var filter = createFilterByNumberCopy(matrix,i)
		var comps = getAllConnectedComponents(filter)
		for comp in comps:
			points += i * comp.size() * comp.size()
	return points
	
func getPointsForAllTypes(matrix = boardState):
	var allPoints = [0,0,0,0]
	for i in range(4):
		allPoints[i] = getPointsForOneType(createFilterByTypeCopy(matrix,i))
	return allPoints

func getIndustryPointsWithoutClusters() -> int:
	if boardState == []:
		return 0
	var filteredByType = createFilterByTypeCopy(boardState, TYPE.INDUSTRY)
	return getSumOfNonNullEntries(filteredByType)

func getNumberOfIndustryBuildings() -> int:
	var filteredByType = createFilterByTypeCopy(boardState, TYPE.INDUSTRY)
	return getNumberOfNonNullEntries(filteredByType)
	
func getNumberOfNonNullEntries(matrix) -> int:
	var result = 0
	var rows = matrix.size()
	var columns = matrix[0].size()
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column] != 0:
				result += 1
	return result
	
func getSumOfNonNullEntries(matrix) -> int:
	var result = 0
	var rows = matrix.size()
	var columns = matrix[0].size()
	for row in range(rows):
		for column in range(columns):
			if matrix[row][column] != 0:
				result += matrix[row][column]
	return result

func negativeImpact(i,j):
	
	var clusterType = boardState[i][j]
	var filteredByType = createFilterByTypeCopy(boardState, clusterType[1])
	var filteredByNumber = createFilterByNumberCopy(filteredByType, clusterType[0])
	var conComp = getOneConnectedComponent(filteredByNumber,i,j)
	
	if conComp.size() == 1:
		return
	else:
		var malus = min(conComp.size()-1, clusterType[0])
		for member in conComp:
			var negativelyImpacted = []
			if member[0] >0:
				if boardState[member[0]-1][member[1]][0] > 0:
					if boardState[member[0]-1][member[1]][1]!=clusterType[1]:
						negativelyImpacted.append([ member[0]-1 ,member[1] ])
						boardState[member[0]-1][member[1]][0] = max(0,boardState[member[0]-1][member[1]][0]-malus)
			if member[0] < GameManager.gridWidth - 1:
				if boardState[member[0]+1][member[1]][0] > 0:
					if boardState[member[0]+1][member[1]][1]!=clusterType[1]:
						negativelyImpacted.append([ member[0]+1 ,member[1] ])
						boardState[member[0]+1][member[1]][0] = max(0,boardState[member[0]+1][member[1]][0]-malus)
			if member[1]>0:
				if boardState[member[0]][member[1]-1][0] > 0:
					if boardState[member[0]][member[1]-1][1]!=clusterType[1]:
						negativelyImpacted.append([ member[0] ,member[1]-1 ])
						boardState[member[0]][member[1]-1][0] = max(0,boardState[member[0]][member[1]-1][0]-malus)
			if member[1]<GameManager.gridHeight-1:
				if boardState[member[0]][member[1]+1][0] > 0:
					if boardState[member[0]][member[1]+1][1]!=clusterType[1]:
						negativelyImpacted.append([ member[0] ,member[1]+1 ])
						boardState[member[0]][member[1]+1][0] = max(0,boardState[member[0]][member[1]+1][0]-malus)
			
			for impactedTile in negativelyImpacted:
				GameManager.boardRenderer.indexToTileDict[impactedTile].showNegativeImpact(malus)

func indexToClusterSize(i,j):
	var valueAtIndex = boardState[i][j]
	if valueAtIndex[0] < 1:
		return 0
	
	var filteredByType = createFilterByTypeCopy(boardState, valueAtIndex[1])
	var filteredByNumber = createFilterByNumberCopy(filteredByType, valueAtIndex[0])
	var cluster = getOneConnectedComponent(filteredByNumber,i,j)
	return cluster.size()
