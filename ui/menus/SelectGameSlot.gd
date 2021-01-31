extends BaseMenu

class_name SelectGameSlotNode

onready var left: = $VBoxContainer/HBoxContainer_1/VBoxContainer_right
onready var right: = $VBoxContainer/HBoxContainer_1/VBoxContainer_left

var col:int=0
var row:int=0

signal start_level(slot, level, score)

func _ready():
	load_slots_into_buttons()
	update_buttons()
	
func slot_number()->int:
	return col*5 + row + 1
	
func load_slots_into_buttons()->void:
	for ix in range(1, 11):
		var slot:GameSlot = GameSlot.new(ix)
		slot.load()
		if slot.level<2 and slot.score==0:
			button_is_new_game(ix)
		else:
			button_is_active_game(ix, slot.level, slot.score)

func button_is_active_game(slot:int, level:int, score:int)->void:
	var btn:Button = get_button(slot)
	btn.text="Level: "+str(level)+", Score: "+Utils.spaceSep(score)
	
func get_button(ix:int)->Button:
	for btn in left.get_children():
		if btn is Button:
			if btn.name == "slot_"+str(ix):
				return btn
	for btn in right.get_children():
		if btn is Button:
			if btn.name == "slot_"+str(ix):
				return btn
	return null
				
func button_is_new_game(ix:int):
	var btn:Button = get_button(ix)
	btn.text="Empty Game Slot"
	
func update_buttons()->void:
	sfx.play(sfx.sound.box_moved)
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
	if Input.is_action_just_pressed("btn_a"):
		var slot:GameSlot = GameSlot.new(slot_number())
		emit_signal("start_level", slot_number(), slot.level, slot.score)
	if Input.is_action_just_pressed("btn_y"):
		var slot:GameSlot = GameSlot.new(slot_number())
		slot.erase()
		load_slots_into_buttons()
		
	._physics_process(delta)
