extends BaseMenu

class_name AboutMenu

onready var scroller:ScrollContainer = $VBoxContainer/ScrollContainer

var position:float = 0

func _ready() -> void:
	container = $VBoxContainer

func _physics_process(delta):
	if Input.is_action_pressed("up"):
		position-=500*delta

	if Input.is_action_pressed("down"):
		position+=500*delta

	scroller.scroll_vertical=position
	position = clamp(position, 0, scroller.scroll_vertical+1)
	
		
	._physics_process(delta)
