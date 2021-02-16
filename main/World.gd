extends Node

# warning-ignore-all:return_value_discarded

class_name WorldNode

onready var die_ps:PackedScene = PackedScenes.DieNode
onready var levelMap_ps:PackedScene = PackedScenes.LevelMap
onready var player_ps:PackedScene = PackedScenes.Player
onready var FadeOutIn:PackedScene = PackedScenes.FadeOutIn

onready var map:LevelMap = $LevelMap
onready var player:PlayerNode = $Player
onready var tm:TileMap = $LevelMap/TileMap
onready var music:Music = $LevelMap/Music

var camera:Camera2D
var score:int=0
var slot:int=0
var level:int=1

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

func load_level(_level:int)->void:
	self.level=_level

	var fader:FadeOutIn = FadeOutIn.instance()
	get_tree().root.add_child(fader)
	fader.connect("transition_mid", self, "__load_level1")
	fader.connect("transition_end", self, "__load_level2")
	fader.fade()
	
func __load_level1()->void:	
	print("Load level: "+str(level))
	if is_instance_valid(map):
		map.queue_free()
	if is_instance_valid(player):
		player.queue_free()
	
	map = levelMap_ps.instance()
	call_deferred("add_child", map)
	yield(map, "ready")
	
	player = player_ps.instance()
	call_deferred("add_child", player)
	yield(player, "ready")
	
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
	
	player.reset_stats()	
	var p:Vector2=map.randomPortal()	
	player.setGlobalPosition(p)
	
	map.player=player
	
func __load_level2()->void:
	camera.smoothing_enabled=true
	player.cameraFollow.remote_path = camera.get_path()
	
func _on_LevelMap_challenge_changed(number) -> void:
	emit_signal("challenge_changed", number)

func _on_LevelMap_score_add(number:int) -> void:
	score += number
	emit_signal("score_changed", score)

func next_level(_level:int):
	var gslot:GameSlot = GameSlot.new(slot)
	gslot.level=_level+1
	gslot.score=score
	gslot.save()
	load_level(gslot.level)
