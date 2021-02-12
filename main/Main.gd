extends Node

class_name Main

onready var FadeOutIn:PackedScene = PackedScenes.FadeOutIn
onready var startMenu:PackedScene = PackedScenes.StartMenu
onready var playMenu:PackedScene = PackedScenes.SelectGameSlot
onready var optionsMenu:PackedScene = PackedScenes.OptionsMenu
onready var aboutMenu:PackedScene = PackedScenes.AboutMenu

onready var world: = $World
onready var ui = $UI
#onready var map:LevelMap = $World/LevelMap
onready var player:PlayerNode = $World/Player
onready var camera:Camera2D = $Camera2D
onready var playerHud:PlayerHud = $PlayerHud

var showNumber:bool = true

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
# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "joy_connection_changed")
	call_deferred("show", startMenu)
	
# warning-ignore:return_value_discarded
	playerHud.connect("quit_level", self, "quit_level")
# warning-ignore:return_value_discarded
	playerHud.connect("resume_level", self, "resume_level")
	
	playerHud.visible=false
	playerHud.pauseMenu.visible=false
	
func updateInputMap()->void:
	var event: = InputEventKey.new()
	event.scancode = KEY_PERIODCENTERED # TV Controller "enter"
	InputMap.action_add_event("btn_a", event)

"""
Load additionals to the most recent gamecontrollerdb.txt available at time of project build.
See also: https://github.com/gabomdq/SDL_GameControllerDB/blob/master/gamecontrollerdb.txt
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
#	if scene == null:
#		var fader:FadeOutIn = FadeOutIn.instance()
#		get_tree().root.add_child(fader)
#		# warning-ignore:return_value_discarded
#		fader.connect("transition_mid", self, "ui_clear")
#		fader.fade()
#		return

	var menu = scene.instance()
	print("UI Menu: "+menu.name)

	var fader:FadeOutIn = FadeOutIn.instance()
	get_tree().root.add_child(fader)
# warning-ignore:return_value_discarded
	fader.connect("transition_mid", self, "__show", [menu])
	fader.fade()

func __show(menu)->void:
	ui_clear()
	ui.add_child(menu)
	
	if menu.has_signal("main_menu") and not menu is StartMenu:
		menu.connect("main_menu", self, "main_menu")
		
	if menu is StartMenu:
		menu.connect("play_game", self, "play_game")
		menu.connect("options", self, "options")
		menu.connect("about", self, "about")
		menu.connect("quit", self, "quit")
		
	if menu is SelectGameSlotNode:
		menu.connect("start_level", self, "start_level")

func quit_level():
	numberAudio.stop()
# warning-ignore:unsafe_method_access
	world.clear_level()
	playerHud.visible=false
	playerHud.pauseMenu.visible=false
	get_tree().paused=true
	show(startMenu)
	
func resume_level():
	get_tree().paused=false
	playerHud.pauseMenu.visible=false

func play_game() -> void:
# warning-ignore:unsafe_method_access
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
	
func start_level(slot:int, level:int, score:int)->void:	
	get_tree().paused=false
	ui_clear()
	world.clear_level() #clear out previous game
	print("Start Level: "+str(slot)+", "+str(level)+", "+str(score))
	playerHud.visible=true
	playerHud.score.text=Utils.spaceSep(score)
	world.slot = slot
	world.score = score
	world.load_level(level)

func _on_World_pause_level() -> void:
	get_tree().paused=true
	playerHud.pauseMenu.visible=true

func _on_World_challenge_changed(number:int) -> void:
	if number<1:
		playerHud.challenge.text="ᏄᎳ! ᏄᎳ!"
		return
	var text:String = ChallengeAudioText.getCardinal(number)
	if showNumber:
		playerHud.challenge.text=text+" ["+str(number)+"]"
		print("Challenge: "+text+" ["+str(number)+"]")
	else:
		playerHud.challenge.text=text
		print("Challenge: "+text)

func _on_World_score_changed(number) -> void:
	playerHud.score.text=Utils.spaceSep(number)

func _on_World_start_level(slot, level, score) -> void:
	start_level(slot, level, score)
