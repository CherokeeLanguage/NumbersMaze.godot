extends Object

class_name MazeGenerator

const MAZE_HOLE_MODULO:int = 40

var rseed:int
var width:int
var height:int
var level:int

var maze:Array
var portals:Array

var rng:RandomNumberGenerator

func _init():
	rseed = 0
	level=1
	
func dump()->void:
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
# warning-ignore:unsafe_cast
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
# warning-ignore:integer_division
	width = level + 7
	if (width > 16):
		width = 16 + level / 9
	height = width * 9 / 16
	
	width=min(width, 50)
	height=min(height, 50)
	
	print("map size: "+str(width)+" x "+str(height))
	
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
# warning-ignore:unsafe_cast
		if cx>=0 and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
		
		#Check East
		cx = x + 1
		cy = y
# warning-ignore:unsafe_cast
		if cx < width and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
			
		#Check North
		cx = x
		cy = y - 1
# warning-ignore:unsafe_cast
		if cy >= 0 and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
	
		#Check South
		cx = x
		cy = y + 1
# warning-ignore:unsafe_cast
		if cy < height and (maze[cx][cy] as MazeCell).hasAllWalls():
			neighbors.append(Vector2(cx, cy))
		
		if not neighbors.empty():
			var next = rng.randi_range(0, neighbors.size()-1)
# warning-ignore:unsafe_cast
			var newCell: = (neighbors[next] as Vector2)

			if newCell.x < currentCell.x:
# warning-ignore:unsafe_cast
				(maze[newCell.x][newCell.y] as MazeCell).wall.e = false
# warning-ignore:unsafe_cast
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.w = false
			elif newCell.x > currentCell.x:
# warning-ignore:unsafe_cast
				(maze[newCell.x][newCell.y] as MazeCell).wall.w = false
# warning-ignore:unsafe_cast
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.e = false
			elif newCell.y < currentCell.y:
# warning-ignore:unsafe_cast
				(maze[newCell.x][newCell.y] as MazeCell).wall.s = false
# warning-ignore:unsafe_cast
				(maze[currentCell.x][currentCell.y] as MazeCell).wall.n = false
			elif newCell.y > currentCell.y:
# warning-ignore:unsafe_cast
				(maze[newCell.x][newCell.y] as MazeCell).wall.n = false
# warning-ignore:unsafe_cast
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
# warning-ignore:unsafe_cast
			currentCell=(stack.pop_back() as Vector2)
			
	for x in range(0, width):
		for y in range(0, height):
# warning-ignore:unsafe_cast
			var cell: = (maze[x][y] as MazeCell)
			if cell.isPortal():
				portals.append(Vector2(x, y))
				
	if level>7:
		print("- processing extra wall removal")
		var oCell:MazeCell
		var x:int=width/2#for x in range(max(width/2-4, 1), min(width/2+5, width-1), 8):
		
		print(" - [y]")
		for _y in range(max(height/3, 1), min(height*2/3+1, height-1)):
			var cell: = (maze[x][_y] as MazeCell)
			if cell.isPortal():
				continue
			print(" - removing walls at: "+str(Vector2(x,_y)))
			if cell.wall.n:
				oCell=(maze[x][_y-1] as MazeCell)
				if not oCell.isPortal():
					cell.wall.n=false
					oCell.wall.s=false
			if cell.wall.s:
				oCell=(maze[x][_y+1] as MazeCell)
				if not oCell.isPortal():
					cell.wall.s=false
					oCell.wall.n=false

		print("")
		print(" - [x]")
		for _x in range(max(width/3, 1), min(width*2/3+1, width-1)):
			var y:int=height/2
			var cell: = (maze[_x][y] as MazeCell)
			if cell.isPortal():
				continue
			print(" - removing walls at: "+str(Vector2(_x,y)))
			if cell.wall.e:
				oCell=(maze[_x+1][y] as MazeCell)
				if not oCell.isPortal():
					cell.wall.e=false
					oCell.wall.w=false
			if cell.wall.w:
				oCell=(maze[_x-1][y] as MazeCell)
				if not oCell.isPortal():
					cell.wall.w=false
					oCell.wall.e=false
		print("")
#	for x in range(1, width-1):
#		for y in range(1, height-1):
#			var cell: = (maze[x][y] as MazeCell)
#			if not cell.isPortal():
#				if cell.wall.n and rng.randi() % MAZE_HOLE_MODULO == 0:
#					cell.wall.n=false
#					(maze[x][y-1] as MazeCell).wall.s=false
#				if cell.wall.s and rng.randi() % MAZE_HOLE_MODULO == 0:
#					cell.wall.s=false
#					(maze[x][y+1] as MazeCell).wall.n=false
#				if cell.wall.e and rng.randi() % MAZE_HOLE_MODULO == 0:
#					cell.wall.e=false
#					(maze[x+1][y] as MazeCell).wall.w=false
#				if cell.wall.w and rng.randi() % MAZE_HOLE_MODULO == 0:
#					cell.wall.w=false
#					(maze[x-1][y] as MazeCell).wall.e=false

			
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
