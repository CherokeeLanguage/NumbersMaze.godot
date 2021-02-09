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
var showNumber:bool = true
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
	yield(get_tree(),"idle_frame")
	ev.pressed=true
	Input.parse_input_event(ev)

func _ready():	
	updateInputMap()
	addControllerMappings()
	world.camera=camera
	show(startMenu)
	# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "joy_connection_changed")
	
func updateInputMap()->void:
	var event: = InputEventKey.new()
	event.scancode = KEY_PERIODCENTERED # TV Controller "enter"
	InputMap.action_add_event("btn_a", event)

func _physics_process(_delta: float) -> void:
	pass
		
"""
Load the most recent gamecontrollerdb.txt available at time of project build.

See: https://github.com/gabomdq/SDL_GameControllerDB/blob/master/gamecontrollerdb.txt
"""
func addControllerMappings()->void:
	var count:int = 0
	var f:File = File.new()
	if f.open("res://gamepad/controllerdb.txt", File.READ) != OK:
		return
	while not f.eof_reached():
		var mapping:String=f.get_line().strip_edges()
		if mapping.begins_with("#"):
			continue
		if mapping.empty():
			continue
		Input.add_joy_mapping(mapping, true)
		count+=1		
	f.close()
	print("Added/updated %d joypad mappings."%count)
	
func removeControllerMappings()->void:	
	var count:int = 0
	var f:File = File.new()
	if f.open("res://gamepad/controllerdb.txt", File.READ) != OK:
		return
	while not f.eof_reached():
		var mapping:String=f.get_line().strip_edges()
		if mapping.begins_with("#"):
			continue
		if mapping.empty():
			continue
		var guid: = ""
		for ix in range(mapping.length()):
			if mapping[ix]==",":
				break
			guid += mapping[ix]
		Input.remove_joy_mapping(guid)
		count+=1
	f.close()
	print("Removed %d joypad mappings."%count)
	
func joy_connection_changed(index:int, connected:bool)->void:
	print("Joypad: joy_connection_changed("+str(index)+", "+str(connected)+")")
	print("Joypad: "+Input.get_joy_guid(index)+", "+Input.get_joy_name(index))
	for ix in range(8):
		if Input.get_joy_guid(ix).empty():
			continue
		print("Joypad: "+str(ix)+", "+Input.get_joy_guid(ix)+", "+Input.get_joy_name(ix))

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
	world.clear_level() #clear out previous game
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
	world.clear_level() #clear out previous game
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
		if number<1:
			activeHud.challenge.text="ᏄᎳ! ᏄᎳ!"
			return
		var text:String = ChallengeAudioText.getCardinal(number)
		if showNumber:
			activeHud.challenge.text=text+" ["+str(number)+"]"
			print("Challenge: "+text+" ["+str(number)+"]")
		else:
			activeHud.challenge.text=text
			print("Challenge: "+text)
			

func _on_World_score_changed(number) -> void:
	if is_instance_valid(activeHud):
		activeHud.score.text=Utils.spaceSep(number)


func _on_World_start_level(slot, level, score) -> void:
	start_level(slot, level, score)
