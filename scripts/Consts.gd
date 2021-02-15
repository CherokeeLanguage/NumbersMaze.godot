extends Node

class_name Consts

const PLAYER_EXPLOSION:String = "player-explosion"
const CHAINED_DICE_EXPLOSION:String = "chained-dice-explosion"
const GROUP_DICE:String = "dice"

export var path: = "res://audio/effects"

var effects:Dictionary = {}

func _init() -> void:
	var f: = File.new()
	var _x = f.open(path+"/plist.txt", File.READ)
		
	while not f.eof_reached():
		var name = f.get_line()
		if name.strip_edges().empty():
			continue
		var key = name.get_basename().to_lower()
		effects[key]=load(path+"/"+name)

func effect(effect:String) -> AudioStream:
	effect = effect.to_lower()
	if not(effect in effects.keys()):
		print_debug("Effect "+effect+" not found")
		return null
	return effects[effect]

class fx:
	const box_moved = "box_moved"
	const ding = "ding"
	const drop_it = "drop_it"
	const explode = "explode"
	const explodemini = "explodemini"
	const growl =  "growl"
	const level_finished = "level_finished"
	const pick_up =  "pick_up"
	const plink = "plink"
