extends Control

class_name BaseMenu

onready var _sfx:SoundFx = $_SoundFx
onready var _music:Music = $_Music
onready var _timer:Timer = $_Timer

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

"""
Adjusts MARGIN to account for some TVs with cropping issues.
'container' must be set by child class
"""
func tv_zoom(value:float):
	value = 1 - value
	if container == null or not is_instance_valid(container):
		return
	if not container is Control:
		return
	var control = container as Control
	var x: = size.x*value/2
	var y: = size.y*value/2
	control.margin_bottom=-y
	control.margin_left=x
	control.margin_right=-x
	control.margin_top=y

func _exit_tree() -> void:
	_music.list=[]
	_music.stop()
