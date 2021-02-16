extends BaseMenu

class_name OptionsMenu

signal master_volume(percent)
signal fx_volume(percent)
signal music_volume(percent)
signal tv_zoom(percent)

onready var music:Music = $Music

onready var master_volume:ProgressBar = $VBox/HBox_2/ProgressBar
onready var fx_volume:ProgressBar = $VBox/HBox_3/ProgressBar
onready var music_volume:ProgressBar = $VBox/HBox_4/ProgressBar
onready var tv_zoom:ProgressBar = $VBox/HBox_1/ProgressBar
onready var tv_box:HBoxContainer = $VBox/HBox_1

var ix:int = 0
var count:int = 0
var buttons:Array = []

func _ready() -> void:
	container = $VBox
	buttons.append($VBox/HBox_2/MasterVolume)
	buttons.append($VBox/HBox_3/FxVolume)
	buttons.append($VBox/HBox_4/MusicVolume)
	buttons.append($VBox/HBox_1/TvZoom)
	count = buttons.size()
	update_buttons()
	music.list=["res://audio/music/DoKashiteru_-_Yiourgh.ogg"]
	music.play()
	
	tv_box.visible = OS.get_name().begins_with("Android")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		inc_value(-1)
	if Input.is_action_just_pressed("right"):
		inc_value(+1)
	if Input.is_action_just_pressed("up"):
		ix = (ix-1)%count
		update_buttons()
	if Input.is_action_just_pressed("down"):
		ix = (ix+1)%count
		update_buttons()
	._physics_process(delta)
	
func inc_value(percent:int)->void:
	sfx()
	match ix:
		0:
			inc_master_volume(percent*5)
		1:
			inc_fx_volume(percent*5)
		2:
			inc_music_volume(percent*5)
		3:
			inc_tv_zoom(percent)
			

func inc_master_volume(percent:int)->void:
	master_volume.value+=percent
	emit_signal("master_volume", master_volume.value)
	
func inc_fx_volume(percent:int)->void:
	fx_volume.value+=percent
	emit_signal("fx_volume", fx_volume.value)
	
func inc_music_volume(percent:int)->void:
	music_volume.value+=percent
	emit_signal("music_volume", music_volume.value)
	
func inc_tv_zoom(percent:int)->void:
	tv_zoom.value+=percent
	emit_signal("tv_zoom", tv_zoom.value)

func update_buttons() -> void:
	sfx()
	for button in buttons:
		(button as Button).disabled=true
	(buttons[ix] as Button).disabled=false
