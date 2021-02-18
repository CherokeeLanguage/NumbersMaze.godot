extends BaseMenu

class_name StartMenu

var buttons:Array = []
var ix:int = 0
var count:int = 0
var is_html:bool = false

signal play_game
signal options
signal how_to_play
signal about
signal quit

func _ready():
	container = $VBoxContainer
	
	buttons.append($VBoxContainer/PlayGame)
	buttons.append($VBoxContainer/Options)
	buttons.append($VBoxContainer/HowToPlay)
	buttons.append($VBoxContainer/About)
	buttons.append($VBoxContainer/Quit)
	count = buttons.size()
	
	_music.list = ["res://audio/music-startmenu/George_Ellinas_-_Pulse_(George_Ellinas_remix).ogg"]
	_music.play()
	
	is_html = OS.get_name() == "HTML5"
	($VBoxContainer/Quit as Button).visible=!is_html

func _physics_process(_delta):
	if Input.is_action_just_pressed("up"):
		ix = posmod(ix-1, count)
		if is_html and ix == count - 1:
			ix = count - 2
		update_buttons()
		return

	if Input.is_action_just_pressed("down"):
		ix = posmod(ix+1, count)
		if is_html and ix == count - 1:
			ix = 0
		update_buttons()
		return

	if Input.is_action_just_pressed("btn_select") and not is_html:
		if ix+1 == count:
			emit_signal("quit")
		else:
			ix=count-1
			update_buttons()
		return

	if Input.is_action_just_pressed("btn_a"):
		match ix:
			0:
				emit_signal("play_game")
			1:
				emit_signal("options")
			2:
				emit_signal("how_to_play")
			3:
				emit_signal("about")
			4:
				emit_signal("quit")
	
func update_buttons() -> void:
	sfx()
	for button in buttons:
		(button as Button).disabled=true
	(buttons[ix] as Button).disabled=false
