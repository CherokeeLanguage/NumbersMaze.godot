extends Node

class_name Main

onready var world = $World
onready var ui = $UI
onready var map = $World/LevelMap
onready var player = $World/Player
onready var camera = $Camera2D

var startMenu:PackedScene = preload("res://ui/menus/StartMenu.tscn")
var playMenu:PackedScene = preload("res://ui/menus/SelectGameSlot.tscn")
var optionsMenu:PackedScene = preload("res://ui/menus/OptionsMenu.tscn")
var aboutMenu:PackedScene = preload("res://ui/menus/AboutMenu.tscn")

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
	get_tree().paused=true
	world.camera=camera
	show(startMenu)

func ui_clear()->void:
	for child in ui.get_children():
		child.queue_free()
		
func show(scene:PackedScene):
	ui_clear()
	var menu = scene.instance()
	if menu is BaseMenu:
		menu._connect("play_game", self, "play_game")
		menu._connect("options", self, "options")
		menu._connect("about", self, "about")
		menu._connect("quit", self, "quit")
		if not (menu is StartMenu):
			menu._connect("main_menu", self, "main_menu")
	if menu is SelectGameSlotNode:
		menu._connect("start_level", self, "start_level")
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
	
func start_level(slot, level, score)->void:
	print("Start Level: "+str(slot)+", "+str(level)+", "+str(score))
	ui_clear()
	world.slot = slot
	world.score = score
	world.load_level(level)

func _on_World_quit_level() -> void:
	world.pause_mode=true
	show(startMenu)
