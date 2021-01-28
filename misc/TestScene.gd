extends Node

onready var map = $LevelMap
onready var player = $Player

func _ready():
	var p:Vector2
	p = map.randomPortal()
	p = map.randomPortal()
	p.x += 128+96
	p.y += 128+96
	player.setGlobalPosition(p)
	print(str(p))
