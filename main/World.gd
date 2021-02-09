extends Node

# warning-ignore-all:return_value_discarded

class_name WorldNode

const die_ps:PackedScene = preload("res://nodes/DieNode.tscn")
const levelMap_ps:PackedScene = preload("res://levels/LevelMap.tscn")
const player_ps:PackedScene = preload("res://player/Player.tscn")

onready var map:LevelMap = $LevelMap
onready var player:PlayerNode = $Player
onready var tm:TileMap = $LevelMap/TileMap
onready var music:Music = $LevelMap/Music

var camera:Camera2D
var score:int=0
var slot:int=0

signal pause_level
signal challenge_changed(number)
signal score_changed(number)

func _ready():
	clear_level()
	
func clear_level():
	if is_instance_valid(map):
		map.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	map = null
	player = null
	
func _physics_process(_delta: float) -> void:
	if not is_instance_valid(map) or not map.visible:
		return
	pause_check()
	
func pause_check()->void:
	if Input.is_action_just_pressed("btn_select"):
		emit_signal("pause_level")

func challenge_update(number:int):
	emit_signal("challenge_changed", number)

func load_level(level:int)->void:
	print("Load level: "+str(level))
	if is_instance_valid(map):
		map.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	
	map = levelMap_ps.instance()
	add_child(map)
	
	player = player_ps.instance()
	add_child(player)
	
	music=map.music
	tm=map.map
		
	map.connect("challenge_changed", self, "_on_LevelMap_challenge_changed")
	map.connect("score_add", self, "_on_LevelMap_score_add")
	map.connect("next_level", self, "next_level")
	
	map.level=level
	map.generate()
	
	camera.smoothing_enabled=false
	camera.position=map.size/2
	camera.align()
	camera.smoothing_enabled=true
	
	var p:Vector2=map.randomPortal()
	player.reset_stats()
	player.setGlobalPosition(p)
	player.cameraFollow.remote_path = camera.get_path()

	get_tree().paused=false
	
func _on_LevelMap_challenge_changed(number) -> void:
	emit_signal("challenge_changed", number)

func _on_LevelMap_score_add(number:int) -> void:
	score += number
	emit_signal("score_changed", score)

func next_level(level:int):
	if is_instance_valid(map):
		map.queue_free()
	map = null
	if is_instance_valid(player):
		player.queue_free()
	player = null
	var gslot:GameSlot = GameSlot.new(slot)
	gslot.level=level+1
	gslot.score=score
	gslot.save()
	load_level(level+1)
