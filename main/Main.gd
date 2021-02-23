extends Node

#class_name Main

onready var HowToPlay:PackedScene = PackedScenes.HowToPlay
onready var FadeOutIn:PackedScene = PackedScenes.FadeOutIn
onready var startMenu:PackedScene = PackedScenes.StartMenu
onready var playMenu:PackedScene = PackedScenes.SelectGameSlot
onready var optionsMenu:PackedScene = PackedScenes.OptionsMenu
onready var aboutMenu:PackedScene = PackedScenes.AboutMenu

onready var world:WorldNode = $World
onready var ui = $UI
#onready var map:LevelMap = $World/LevelMap
onready var player:PlayerNode = $World/Player
onready var camera:Camera2D = $Camera2D
onready var playerHud:PlayerHud = $PlayerHud

var game_settings:GameSettings

var is_tv:bool = false

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

	print(" ")
	print("=== PLATFORM: "+OS.get_model_name()+" ["+OS.get_name()+"]")
	for argument in OS.get_cmdline_args():
		if argument.begins_with("--tv="):
			if argument == "--tv=true":
				is_tv = true
			else:
				is_tv = false
			break
	print("--- TV: "+str(is_tv))	
	print(" ")
	print("Physic iterations/second: "+str(Engine.iterations_per_second))
	print(" ")
	
	game_settings = GameSettings.new()
	
	Utils.setFxVolume(game_settings.volume_fx)
	Utils.setMasterVolume(game_settings.volume_master)
	Utils.setMusicVolume(game_settings.volume_music)
	set_tv_zoom(game_settings.tv_zoom)
	
	updateInputMap()
	addControllerMappings()
	world.camera=camera
# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "joy_connection_changed")
	call_deferred("show_ui", startMenu)
	
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
	if connected:
		print("Gamepad detected: "+Input.get_joy_guid(index)+", "+Input.get_joy_name(index))

func ui_clear()->void:
	for child in ui.get_children():
		child.queue_free()
		
func show_ui(scene:PackedScene):
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
	reset_ui_margin()
	
	if menu.has_signal("main_menu") and not menu is StartMenu:
		menu.connect("main_menu", self, "main_menu")
		
	if menu is StartMenu:
		menu.connect("play_game", self, "play_game")
		menu.connect("options", self, "options")
		menu.connect("how_to_play", self, "how_to_play")
		menu.connect("about", self, "about")
		menu.connect("quit", self, "quit")
		
	if menu is SelectGameSlotNode:
		menu.connect("start_level", self, "start_level")
		
	if menu is OptionsMenu:
		var oMenu = (menu as OptionsMenu)
		oMenu.connect("master_volume", self, "set_master_volume")
		oMenu.connect("fx_volume", self, "set_fx_volume")
		oMenu.connect("music_volume", self, "set_music_volume")
		oMenu.connect("tv_zoom", self, "set_tv_zoom")
		
		oMenu.master_volume.value=game_settings.volume_master
		oMenu.fx_volume.value=game_settings.volume_fx
		oMenu.music_volume.value=game_settings.volume_music
		oMenu.tv_zoom.value=game_settings.tv_zoom

func how_to_play():
	show_ui(HowToPlay)

func quit_level():
	numberAudio.stop()
# warning-ignore:unsafe_method_access
	world.clear_level()
	playerHud.visible=false
	playerHud.pauseMenu.visible=false
	get_tree().paused=true
	show_ui(startMenu)
	
func resume_level():
	get_tree().paused=false
	playerHud.pauseMenu.visible=false

func play_game() -> void:
# warning-ignore:unsafe_method_access
	world.clear_level() #clear out previous game
	show_ui(playMenu)

func options() -> void:
	show_ui(optionsMenu)

func about() -> void:
	show_ui(aboutMenu)	

func quit() -> void:
	get_tree().quit()
	
func main_menu()->void:
	show_ui(startMenu)
	
func start_level(slot:int, level:int, score:int)->void:	
	get_tree().paused=false
	ui_clear()
	(world as WorldNode).clear_level() #clear out previous game
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
	if number>world.level*3/2 - 4:
		playerHud.challenge.text=text+" ["+str(number)+"]"
		print("Challenge: "+text+" ["+str(number)+"]")
	else:
		playerHud.challenge.text=text
		var q:String="?"
		if number > 9:
			q = "??"
		if number > 99:
			q = "???"
		print("Challenge: "+text+" ["+q+"]")

func _on_World_score_changed(number) -> void:
	playerHud.score.text=Utils.spaceSep(number)

func _on_World_start_level(slot, level, score) -> void:
	start_level(slot, level, score)

func set_master_volume(value:int)->void:
	if game_settings.volume_master != value:
		game_settings.volume_master = value
		game_settings.save()
	Utils.setMasterVolume(value)
	
func set_fx_volume(value:int)->void:
	if game_settings.volume_fx != value:
		game_settings.volume_fx = value
		game_settings.save()
	Utils.setFxVolume(value)
	
func set_music_volume(value:int)->void:
	if game_settings.volume_music != value:
		game_settings.volume_music = value
		game_settings.save()
	Utils.setMusicVolume(value)

func set_tv_zoom(value:int)->void:
	if game_settings.tv_zoom != value:
		game_settings.tv_zoom = value
		game_settings.save()
		
	var zoom:float = 1+float(game_settings.tv_zoom)/100.0
	print("set_tv_zoom: "+str(value)+" ["+str(zoom)+"]")
	camera.zoom=Vector2(zoom, zoom)
	reset_ui_margin()
	
func reset_ui_margin()->void:
	var zoom:float = 1+float(game_settings.tv_zoom)/100.0
	
	for menu in ui.get_children():
		if menu is BaseMenu:
			menu.tv_zoom(zoom)
			
	playerHud.tv_zoom(zoom)
	
