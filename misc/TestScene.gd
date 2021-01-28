extends Node

var marker_ps:PackedScene = preload("res://misc/TestMarker.tscn")

onready var map = $LevelMap
onready var player = $Player
onready var markers = $Markers
onready var camera = $Camera2D

func _ready():
	
	player.cameraFollow.remote_path = camera.get_path()
	
	map.level=1
	map.generate()
	var p:Vector2
	p = map.randomPortal()
	p = map.randomPortal()
	p = map.randomPortal()
	p = map.randomPortal()
	player.setGlobalPosition(p)
	print(str(p))

	for portal in map.portals:
		var marker = marker_ps.instance()
		markers.add_child(marker)
		marker.global_position=portal
