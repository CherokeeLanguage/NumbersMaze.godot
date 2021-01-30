extends Node

class_name TestSceneNode

var marker_ps:PackedScene = preload("res://misc/TestMarker.tscn")
var die_ps:PackedScene = preload("res://nodes/DieNode.tscn")

onready var map:LevelMap = $LevelMap
onready var player:PlayerNode = $Player
onready var markers: = $Markers
onready var camera:Camera2D = $Camera2D
onready var tm:TileMap = $LevelMap/TileMap

func _ready():
	player.cameraFollow.remote_path = camera.get_path()
	player.position = map.size
	
	map.level=16
	map.generate()
	var p:Vector2
	p = map.randomPortal()
	player.setGlobalPosition(p)
	#player.setGlobalPosition(Vector2(64, 64))

	var rng: = RandomNumberGenerator.new()
	rng.seed=map.level
	for portal in map.portals:
		var marker = die_ps.instance()
		markers.add_child(marker)
		marker.setValue(rng.randi_range(1,6))
		marker.global_position=portal
