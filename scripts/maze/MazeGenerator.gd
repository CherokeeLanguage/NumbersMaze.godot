extends Object

class_name MazeGenerator

var rseed:int
var width:int
var height:int
var level:int

var maze:Array
var portals:Array

var rng:RandomNumberGenerator

func _init():
	print_debug("MazeGenerator#_init")
	rseed = 0
	level=1
	
func dump()->void:
	print_debug("MazeGenerator#dump")
	var chars:Array = []
	for _x in range(0, 16):
		chars.append("")
	chars[0]="░"
	chars[1]="╠"
	chars[2]="╩"
	chars[3]="╚"
	chars[4]="╣"
	chars[5]="║"
	chars[6]="╝"
	chars[7]="╨"
	chars[8]="╦"
	chars[9]="╔"
	chars[10]="═"
	chars[11]="╞"
	chars[12]="╗"
	chars[13]="╥"
	chars[14]="╡"
	chars[15]="█"
	for y in range(0, height):
		y = height-y-1
		var line:String=""
		for x in range(0, width):
			var cell: =(maze[x][y] as MazeCell)
			#w=1 s=2 e=4 n=8
			var ix:int = 0
			if cell.wall.w:
				ix|=1
			if cell.wall.s:
				ix|=2
			if cell.wall.e:
				ix|=4
			if cell.wall.n:
				ix|=8
			line += chars[ix]
			
		print(line)
	
func generate()->void:
	print_debug("MazeGenerator#generator")
	
	width = level / 3 + 7
	height = level / 3 + 4
	if (width > 16):
		width = 16 + level / 16
	if (height > 9):
		height = 9 + level / 9
	
	rng = RandomNumberGenerator.new()
	rng.seed = rseed
	var totalCells:int = width * height
	var neighbors:Array = Array()
	var stack:Array = Array()
	
	maze=[]
	for x in range(0, width):
		maze.append([])
		for _y in range(0, height):
			maze[x].append(MazeCell.new())
	
	var currentCell: = Vector2(rng.randi_range(0, width-1), rng.randi_range(0, height-1))
	var visitedCells:int = 1

	print("Total cells: "+str(totalCells))
	
	while visitedCells<totalCells:
		var cx:int
		var cy:int
		neighbors.clear()
# warning-ignore:narrowing_conversion
		var x:int = currentCell.x
# warning-ignore:narrowing_conversion
		var y:int = currentCell.y
		
		#Check West
		cx = x - 1
		cy = y
		if cx>=0 and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
		
		#Check East
		cx = x + 1
		cy = y
		if cx < width and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
			
		#Check North
		cx = x
		cy = y - 1
		if cy >= 0 and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
	
		#Check South
		cx = x
		cy = y + 1
		if cy < height and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
		
		if not neighbors.empty():
			var next = rng.randi_range(0, neighbors.size()-1)
			var newCell: = (neighbors[next] as Vector2)

			if newCell.x < currentCell.x:
				(maze[newCell.x][newCell.y] as MazeCell).wall.e = false
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.w = false
			elif newCell.x > currentCell.x:
				(maze[newCell.x][newCell.y] as MazeCell).wall.w = false
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.e = false
			elif newCell.y < currentCell.y:
				(maze[newCell.x][newCell.y] as MazeCell).wall.s = false
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.n = false
			elif newCell.y > currentCell.y:
				(maze[newCell.x][newCell.y] as MazeCell).wall.n = false
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.s = false
					
			stack.append(currentCell)
			currentCell = newCell
			visitedCells+=1
		else:
			if stack.empty():
				print_debug("MAZE GEN BUG!")
				print_debug("VISITED CELLS: "+str(visitedCells))
				print_debug("TOTAL CELLS: "+str(totalCells))
				return
			currentCell=(stack.pop_back() as Vector2)
			
	for x in range(0, width):
		for y in range(0, height):
			var cell: = (maze[x][y] as MazeCell)
			if cell.isPortal():
				portals.append(Vector2(x, y))
			
class MazeCell:
	var isSolid:bool = true
	var wall:Walls
	
	func isPortal()->bool:
		var ix:int=0
		if wall.w:
			ix+=1
		if wall.s:
			ix+=1
		if wall.e:
			ix+=1
		if wall.n:
			ix+=1
		return ix==3
	
	func _init():
		wall = Walls.new()

	func hasAllWalls() -> bool:
		return wall.w and wall.s and wall.e and wall.n


class Walls:
	var w:bool = true
	var s:bool = true
	var e:bool = true
	var n:bool = true
