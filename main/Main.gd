extends Node

class_name Main

var startMenu:PackedScene = preload("res://ui/menus/StartMenu.tscn")
var playMenu:PackedScene = preload("res://ui/menus/SelectGameSlot.tscn")
var optionsMenu:PackedScene = preload("res://ui/menus/OptionsMenu.tscn")
var aboutMenu:PackedScene = preload("res://ui/menus/AboutMenu.tscn")

onready var world = $World
onready var ui = $UI
onready var camera = $Camera

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		event_select()
		return

	#Android "back"
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		event_select()
		return

func event_select():
	var ev:InputEventAction = InputEventAction.new()
	ev.action="btn_select"
	ev.pressed=false
	Input.parse_input_event(ev)
	ev.pressed=true
	Input.parse_input_event(ev)

func _ready():
	show(startMenu)

func show(scene:PackedScene):
	for child in ui.get_children():
		child.queue_free()
	var menu = scene.instance()
	if menu is BaseMenu:
		menu._connect("play_game", self, "play_game")
		menu._connect("options", self, "options")
		menu._connect("about", self, "about")
		menu._connect("quit", self, "quit")
		if not (menu is StartMenu):
			menu._connect("main_menu", self, "main_menu")
	ui.add_child(menu)

func play_game() -> void:
	show(playMenu)

func options() -> void:
	show(optionsMenu)

func about() -> void:
	show(aboutMenu)	

func quit() -> void:
	get_tree().quit()
	
func main_menu()->void:
	show(startMenu)
	
