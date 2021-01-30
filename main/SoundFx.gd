extends Node

class_name SoundFx

export var path: = "res://audio/effects"
export var volume_db:float = 0
export var max_channels:int = 32

var channels:Array = []
var effects:Dictionary = {}

var sound:Dictionary = {
	"box_moved": "box_moved",
	"ding": "ding",
	"drop": "drop_it",
	"explode": "explode",
	"explodemini": "explodemini",
	"growl": "growl",
	"level_finished": "level_finished",
	"pick_up": "pick_up",
	"plink": "plink"
}

onready var streams: = $Streams

func _ready() -> void:
	var f: = File.new()
	var _x = f.open(path+"/plist.txt", File.READ) #,"PLIST NOT FOUND: "+path+"/plist.txt")
		
	while not f.eof_reached():
		var name = f.get_line()
		if name.strip_edges().empty():
			continue
		var key = name.get_basename().to_lower()
		effects[key]=load(path+"/"+name)

	#print_debug("Sound FX: "+str(effects.keys()))

func play(effect:String) -> void:
	if (streams.get_child_count()>=max_channels):
		streams.get_children()[0].queue_free()
	effect = effect.to_lower()
	if not(effect in effects.keys()):
		print_debug("Effect "+effect+" not found")
		return
	var channel: = AudioStreamPlayer.new()
	add_child(channel)
	channel.pitch_scale = 1
	channel.stream=effects[effect]
	channel.volume_db=volume_db
	channel.play()
	var _x = channel.connect("finished", channel, "queue_free")
