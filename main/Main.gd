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
var playerHud:PackedScene = preload("res://ui/hud/PlayerHud.tscn")

var activeHud:PlayerHud

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
	print("UI Menu: "+menu.name)
	
	if menu.has_signal("main_menu") and not menu is StartMenu:
		menu.connect("main_menu", self, "main_menu")
		
	if menu is StartMenu:
		menu.connect("play_game", self, "play_game")
		menu.connect("options", self, "options")
		menu.connect("about", self, "about")
		menu.connect("quit", self, "quit")
		
	if menu is SelectGameSlotNode:
		menu.connect("start_level", self, "start_level")
		
	if menu is PlayerHud:
		activeHud=menu
		menu.connect("quit_level", self, "quit_level")
		menu.connect("resume_level", self, "resume_level")
		
	ui.add_child(menu)

func quit_level():
	get_tree().paused=true
	show(startMenu)
	
func resume_level():
	for menu in ui.get_children():
		if menu is PlayerHud:
			menu.pauseMenu.visible=false
	get_tree().paused=false

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
	show(playerHud)
	if is_instance_valid(activeHud):
		activeHud.score.text=Utils.spaceSep(score)
		#activeHud.challenge.text=ChallengeAudioText.getCardinal(0)
	world.slot = slot
	world.score = score
	world.load_level(level)

func _on_World_pause_level() -> void:
	for menu in ui.get_children():
		if menu is PlayerHud:
			menu.pauseMenu.visible=true
	get_tree().paused=true

func _on_World_challenge_changed(number:int) -> void:
	if is_instance_valid(activeHud):
		activeHud.challenge.text=ChallengeAudioText.getCardinal(number)
		print("Challenge: "+ChallengeAudioText.getCardinal(number))
		
