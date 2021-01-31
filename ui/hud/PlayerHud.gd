extends Control

class_name PlayerHud

onready var challenge:Label = $VBoxContainer/Header/Challenge
onready var score:Label = $VBoxContainer/Header/Score
onready var misc:Label = $VBoxContainer/Header/Misc
onready var pauseMenu:Control = $Paused

var buttons:Array = []
var ix:int = 0
var count:int = 0

signal quit_level
signal resume_level

func _ready() -> void:
	pauseMenu.visible=false
	
	buttons.append($Paused/PausedMenu/Resume)
	buttons.append($Paused/PausedMenu/Quit)
	
	count = buttons.size()
	
	update_buttons()
	
	setScore(0)

func _physics_process(_delta: float) -> void:
	if not pauseMenu.visible:
		return
		
	if Input.is_action_just_pressed("up"):
		ix = (ix-1) % count
		update_buttons()
		return

	if Input.is_action_just_pressed("down"):
		ix = (ix+1) % count
		update_buttons()
		return

#	if Input.is_action_just_pressed("btn_select"):
#		emit_signal("resume_level")
#		return
		
	if Input.is_action_just_pressed("btn_a"):
		match ix:
			0:
				emit_signal("resume_level")
			1:
				emit_signal("quit_level")
		return
	
func update_buttons() -> void:
	sfx.play(sfx.sound.box_moved)
	for button in buttons:
		(button as Button).disabled=true
	(buttons[ix] as Button).disabled=false
	

func setScore(value:int):
	score.text=Utils.spaceSep(value)
	
func setChallenge(value:String):
	challenge.text=value


