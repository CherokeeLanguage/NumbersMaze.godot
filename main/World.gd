extends Node

class_name WorldNode

const die_ps:PackedScene = preload("res://nodes/DieNode.tscn")

onready var map:LevelMap = $LevelMap
onready var player:PlayerNode = $Player
onready var tm:TileMap = $LevelMap/TileMap

var camera:Camera2D
var slot:int=0
var score:int=0

signal pause_game
signal quit_level

func _ready():
	player.visible=false
	map.visible=false

func _physics_process(delta: float) -> void:
	if not map.visible:
		return
	pause_check()
	
func pause_check()->void:
	if Input.is_action_just_pressed("btn_select"):
		print("PAUSE!")
		emit_signal("pause_game")

func pause_game()->void:
	player.cameraFollow.remote_path = ""
	
	player.visible=false
	map.visible=false
	
	emit_signal("quit_level")
		
func load_level(level:int)->void:
	get_tree().paused=false
	
	player.visible=true
	map.visible=true
	
	player.reset_stats()
	player.cameraFollow.remote_path = camera.get_path()
	
	map.level=level
	map.generate()
	
	camera.smoothing_enabled=false
	camera.position=map.size/2
	camera.align()
	camera.smoothing_enabled=true
	
	var p:Vector2
	p = map.randomPortal()
	player.setGlobalPosition(p)

	
func _on_World_pause_game() -> void:
	pause_game()
