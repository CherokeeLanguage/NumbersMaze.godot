extends Node2D

class_name LevelMap

onready var map:TileMap = $TileMap
onready var backdrop:TextureRect = $TextureRect

var level:int = 1

var mg:MazeGenerator

var portals:Array
var rng:RandomNumberGenerator

var size:Vector2 = Vector2.ZERO

func _ready():
	pass
	
func randomPortal()->Vector2:
	return portals[rng.randi_range(0, portals.size()-1)]

func generate()->void:
	
	#for random portal selections
	rng = RandomNumberGenerator.new()
	rng.seed=level
	
	#for procgen maze
	mg = MazeGenerator.new()
	mg.rseed=level
	mg.level=level
	mg.generate()
	
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
				
	for portal in mg.portals:
		if portal is Vector2:
			var world_portal:Vector2
			world_portal = map.map_to_world(portal) # top left corner
			world_portal.x+=map.cell_size.x/2
			world_portal.y+=map.cell_size.y/2
			portals.append(world_portal)
			#print(str(portal)+" => "+str(map.map_to_world(portal)))
			
	var floorNumber:int = level % 5
	backdrop.texture = load("res://graphics/floor-tiles/floor"+str(floorNumber)+".png")
	backdrop.rect_global_position=Vector2.ZERO#(64,64)
	backdrop.rect_size.x=map.cell_size.x*mg.width
	backdrop.rect_size.y=map.cell_size.y*mg.height
	
	size=Vector2(backdrop.rect_size.x, backdrop.rect_size.y)

