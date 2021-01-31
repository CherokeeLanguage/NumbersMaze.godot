extends Node

class_name NumberAudio

const path="res://audio/numbers"

var volume_db:float = 0.0
var list: = Array()

onready var channel:AudioStreamPlayer = $Channel_1
var ix: = 0
var count:int

func play(number:int=0):
	stop()
	list = ChallengeAudioText.getAudioSequence(number)
	if list.empty():
		print_debug("NO AUDIO TO PLAY")
		return
	play_next_segment()

func play_next_segment():
	if list.empty():
		return
	channel.stream=load(path+"/"+list.pop_front()+".ogg")
	channel.volume_db=volume_db
	channel.play()

func stop():
	list.clear()
	channel.stop()

func _on_Channel_1_finished():
	channel.stream = null
	play_next_segment()
