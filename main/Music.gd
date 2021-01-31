extends Node

class_name Music

var volume_db:float = 0.0
var list: = Array()

onready var channel:AudioStreamPlayer = $Channel_1
var ix: = 0
var count:int

func play():
	count = list.size()
	if (count<1):
		print_debug("NO MUSIC TO PLAY")
		return
	if channel.pause_mode:
		channel.pause_mode=false
	if channel.playing:
		channel.stop()
	channel.stop()
	channel.stream=load(list[ix])
	channel.volume_db=volume_db
	channel.play()
	print("Music: "+list[ix])
	ix = (ix+1)%count

func pause(pause:bool):
	if not channel.playing:
		return
	channel.pause_mode=pause
	
func stop():
	channel.stop()

func _on_Channel_1_finished():
	channel.stream = null
	play()
