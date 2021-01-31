extends Node

class_name WorldNode

const die_ps:PackedScene = preload("res://nodes/DieNode.tscn")
const levelMap_ps:PackedScene = preload("res://levels/LevelMap.tscn")
const player_ps:PackedScene = preload("res://player/Player.tscn")

onready var map:LevelMap = $LevelMap
onready var player:PlayerNode = $Player
onready var tm:TileMap = $LevelMap/TileMap
onready var music:Music = $LevelMap/Music

var camera:Camera2D
var slot:int=0
var score:int=0

signal pause_level
signal challenge_changed(number)

func _ready():
	player.visible=false
	map.visible=false
	
func _physics_process(_delta: float) -> void:
	if not map.visible:
		return
	pause_check()
	if dieTracker.chain_completed():
		dieTracker.chained_explosions.clear()
	
func pause_check()->void:
	if Input.is_action_just_pressed("btn_select"):
		emit_signal("pause_level")

func challenge_update(number:int):
	emit_signal("challenge_changed", number)

func load_level(level:int)->void:
	map.queue_free()
	map = levelMap_ps.instance()
	add_child(map)
	
	player.queue_free()
	player = player_ps.instance()
	add_child(player)
	
	music=map.music
	tm=map.map
	
	player.reset_stats()
	player.cameraFollow.remote_path = camera.get_path()
	
# warning-ignore:return_value_discarded
	map.connect("challenge_changed", self, "_on_LevelMap_challenge_changed")
	
	map.level=level
	map.generate()
	
	camera.smoothing_enabled=false
	camera.position=map.size/2
	camera.align()
	camera.smoothing_enabled=true
	
	var p:Vector2
	p = map.randomPortal()
	player.setGlobalPosition(p)

	get_tree().paused=false

func _on_LevelMap_challenge_changed(number) -> void:
	emit_signal("challenge_changed", number)
