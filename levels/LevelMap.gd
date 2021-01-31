extends Node2D

class_name LevelMap

const path="res://audio/music"
const die_ps:PackedScene = preload("res://nodes/DieNode.tscn")

onready var map:TileMap = $TileMap
onready var backdrop:TextureRect = $Backdrop
onready var music:Music = $Music

var level:int = 1
var mg:MazeGenerator
var portals:Array
var randomPortals:Array=[]
var rng:RandomNumberGenerator
var size:Vector2 = Vector2.ZERO
var availableTracks:Array=[]
var challenges:Challenges
var currentChallenge:int=0 setget setCurrentChallenge

signal challenge_changed(number)

func _ready():
	load_level_tracks()
	
func _physics_process(_delta: float) -> void:
	if dieTracker.isDieTime():
		var portal: = randomPortal()
		var die:DieNode = die_ps.instance()
		add_child(die)
		die.add_to_group(Consts.GROUP_DICE)
		die.setValue(dieTracker.nextDie())
		die.global_position=portal
	
func load_level_tracks()->void:
	var f: = File.new()
	var _x = f.open(path+"/plist.txt", File.READ) #,"PLIST NOT FOUND: "+path+"/plist.txt")
		
	while not f.eof_reached():
		var name = f.get_line()
		if name.strip_edges().empty():
			continue
		availableTracks.append(path+"/"+name)
	
func randomPortal()->Vector2:
	if randomPortals.empty():
		randomPortals = Utils.shuffle(rng, portals)
	return randomPortals.pop_back()

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
			
	var floorNumber:int = level % 5
	backdrop.texture = load("res://graphics/floor-tiles/floor"+str(floorNumber)+".png")
	backdrop.rect_global_position=Vector2.ZERO#(64,64)
	backdrop.rect_size.x=map.cell_size.x*mg.width
	backdrop.rect_size.y=map.cell_size.y*mg.height
	
	size=Vector2(backdrop.rect_size.x, backdrop.rect_size.y)

	music.list.clear()
	music.list.append(availableTracks[level % availableTracks.size()])
	music.play()

	challenges=Challenges.new(level)
		
	dieTracker.reset(level)
	dieTracker.remaining=challenges.challengeTotalValue
	dieTracker.max_die=challenges.challengeMax
	
	print("Challenges: "+str(challenges.challengeList))
	
	nextChallenge()
	
func nextChallenge():
	if challenges.challengeList.empty():
		self.currentChallenge=0
	else:
		self.currentChallenge=challenges.challengeList.pop_front()

func setCurrentChallenge(number:int):
	currentChallenge=number
	emit_signal("challenge_changed", currentChallenge)
	
