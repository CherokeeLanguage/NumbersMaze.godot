extends BaseMenu

onready var left: = $VBoxContainer/HBoxContainer_1/VBoxContainer_right
onready var right: = $VBoxContainer/HBoxContainer_1/VBoxContainer_left
onready var sfx: = $SoundFx

var col:int=0
var row:int=0

func _ready():
	update_buttons()

func update_buttons()->void:
	sfx.play(MOVE_SOUND)
	var ix=col*5+row+1
	for btn in left.get_children():
		if btn is Button:
			if btn.name == "slot_"+str(ix):
				btn.disabled=false
			else:
				btn.disabled=true
			
	for btn in right.get_children():
		if btn is Button:
			if btn.name == "slot_"+str(ix):
				btn.disabled=false
			else:
				btn.disabled=true

func _physics_process(delta):
	if Input.is_action_just_pressed("right"):
		col = (col+1)%2
		update_buttons()
	if Input.is_action_just_pressed("left"):
		col = (col-1)%2
		update_buttons()
	if Input.is_action_just_pressed("up"):
		row = (row-1)%5
		update_buttons()
	if Input.is_action_just_pressed("down"):
		row = (row+1)%5
		update_buttons()
	._physics_process(delta)
