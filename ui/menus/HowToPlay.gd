extends BaseMenu

class_name HowToPlayScene

onready var scroller:ScrollContainer = $VBoxContainer/ScrollContainer
onready var text_box:RichTextLabel = $VBoxContainer/ScrollContainer/VBoxContainer/bbcode

var position:float = 0


func _ready() -> void:
	container = $VBoxContainer
	var text: = HowToPlayText.new()
	text_box.bbcode_enabled=true
	text_box.bbcode_text=text.text
	menu_music()
	print(text_box.bbcode_text)

func _physics_process(delta):
	if Input.is_action_pressed("up"):
		position-=1000*delta

	if Input.is_action_pressed("down"):
		position+=1000*delta

	scroller.scroll_vertical=position
	position = clamp(position, 0, scroller.scroll_vertical+1)
	
	._physics_process(delta)

func load_text()->void:
	
	return
