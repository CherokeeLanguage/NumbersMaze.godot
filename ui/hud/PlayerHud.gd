extends CanvasLayer

class_name PlayerHud

onready var challenge:Label = $Control/VBoxContainer/Footer/Challenge
onready var score:Label = $Control/VBoxContainer/Header/Score
onready var misc:Label = $Control/VBoxContainer/Header/Misc
onready var pauseMenu:Control = $Control/Paused
onready var control:Control = $Control
onready var sfx: = $SoundFx

var buttons:Array = []
var ix:int = 0
var count:int = 0
var visible:bool = true setget set_visible
var size:Vector2

signal quit_level
signal resume_level

func _ready() -> void:
	pauseMenu.visible=false
	buttons.append($Control/Paused/PausedMenu/Resume)
	buttons.append($Control/Paused/PausedMenu/Quit)
	count = buttons.size()
	update_buttons()
	setScore(0)
	visible=false
	size = OS.get_screen_size()

func _physics_process(_delta: float) -> void:
	if not pauseMenu.visible or not visible:
		return

	if Input.is_action_just_pressed("up"):
		ix = (ix-1) % count
		update_buttons()
		return

	if Input.is_action_just_pressed("down"):
		ix = (ix+1) % count
		update_buttons()
		return

	if Input.is_action_just_pressed("btn_a"):
		match ix:
			0:
				emit_signal("resume_level")
			1:
				emit_signal("quit_level")
		return

func set_visible(value:bool)->void:
	if control != null:
		control.visible=value
	visible=value
	if not visible:
		pauseMenu.visible=false
		
		#reset selected button
		ix=0
		update_buttons()

func update_buttons() -> void:
	sfx.effect(Consts.fx.box_moved)
	for button in buttons:
		(button as Button).disabled=true
	(buttons[ix] as Button).disabled=false

func setScore(value:int):
	score.text=Utils.spaceSep(value)

func setChallenge(value:String):
	challenge.text=value

"""
Adjusts MARGIN to account for some TVs with cropping issues.
"""
func tv_zoom(value:float):
	print("tv_zoom: "+str(value))
	value = 1 - value
	if control == null or not is_instance_valid(control):
		return
	var x: = size.x*value/2
	var y: = size.y*value/2
	control.margin_bottom=-y
	control.margin_left=x
	control.margin_right=-x
	control.margin_top=y
