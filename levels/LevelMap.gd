extends Node2D

class_name LevelMap

onready var map: = $TileMap

var level:int = 1

var mg:MazeGenerator

var portals:Array
var rng:RandomNumberGenerator

func _ready():
	generate()
	
func randomPortal()->Vector2:
	return portals[rng.randi_range(0, portals.size()-1)]

func generate()->void:
	
	#for random portal selections
	rng = RandomNumberGenerator.new()
	rng.seed=level
	
	#for procgen maze
	mg = MazeGenerator.new()
	mg.rseed=level
	mg.generate()
	
	for portal in mg.portals:
		if portal is Vector2:
			portals.append(map.map_to_world(portal))
			print(str(portal)+" => "+str(map.map_to_world(portal)))

	map.set_cell(-1, -1, 20)
	map.set_cell(mg.width, -1, 21)
	map.set_cell(-1, mg.height, 22)
	map.set_cell(mg.width, mg.height, 23)

	for y in range(0, mg.height):
		for x in range(0, mg.width):
			var cell: = mg.maze[x][y] as MazeGenerator.MazeCell
			var wall: = cell.wall
			var ix:int = 0
			
			if wall.n:
				ix|=1
			if wall.e:
				ix|=2
			if wall.s:
				ix|=4
			if wall.w:
				ix|=8
			
			map.set_cell(x, y, ix)
			
			if y==0:
				map.set_cell(x, -1, 16)
			if y==mg.height-1:
				map.set_cell(x, mg.height, 18)
			if x==0:
				map.set_cell(-1, y, 19)
			if x==mg.width-1:
				map.set_cell(mg.width, y, 17)
			
