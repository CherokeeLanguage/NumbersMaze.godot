extends Control

class_name BaseMenu

onready var _sfx:SoundFx = $_SoundFx
onready var _music:Music = $_Music

var size:Vector2
var container:Node

signal main_menu

func _ready() -> void:
	size = OS.get_screen_size()
	
func menu_music()->void:
	_music.stop()
	_music.list=["res://audio/music/DoKashiteru_-_Yiourgh.ogg"]
	_music.play()

func _connect(sig:String, target:Object, method:String, binds: Array=[], flags: int =0) -> void:
	if not has_signal(sig):
		return
	var _x = .connect(sig, target, method, binds, flags)

func _physics_process(_delta):
	if Input.is_action_just_pressed("btn_select"):
		emit_signal("main_menu")

func sfx()->void:
	_sfx.effect(Consts.fx.box_moved)

func _exit_tree() -> void:
	_music.list=[]
	_music.stop()
