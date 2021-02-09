extends Node

class_name DieTracker

onready var timer:Timer=$Timer

var remaining:int = 0 setget setRemaining
var max_die:int = 1
var chained_explosions:Array = []
var chained_explosion_count:int = 0 setget set_chained_explosion_count
var rng:RandomNumberGenerator
var dieTime:bool = false
var valid_die_faces:Array = [1,2,3,4,5,6]
var pending_die_faces:Array = []

func _ready() -> void:
	rng=RandomNumberGenerator.new()
	rng.seed=1
	timer.wait_time=0.15
	timer.one_shot=true
	timer.autostart=false
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "on_Timer_timeout")
	timer.start(0.5)
	
func resetDieTime()->void:
	timer.stop()
	dieTime=false
	timer.start()
	
func endOfChallenges()->bool:
	if remaining>0:
		return false
	if chained_explosions.size()>0:
		return false
	if in_play()>0:
		return false
	return true
	
func isDieTime(portalCount:int=0)->bool:
	if not dieTime:
		return false
	if remaining<1:
		return false
	if chained_explosion_count>0:
		dieTime=false
		timer.start()
		return false
	if in_play() < max_die:
		return true
	if in_play_count() >= portalCount:
		return false
	dieTime=false
	timer.start()
	return true

func timer_start()->void:
	timer.start()

func on_Timer_timeout()->void:
	dieTime=true

"""
Gets the next random die amount. Removes amount from remaining!!!
"""
func nextDie(current_challenge:int):
	var is_in_play:bool = has_in_play(current_challenge)
	var is_valid_die:bool = current_challenge in valid_die_faces
	var amount:int = 0
	while (amount>max_die or amount==0 or amount>remaining):
		if pending_die_faces.empty():
			pending_die_faces=Utils.shuffle(rng, valid_die_faces)
		amount = pending_die_faces.pop_back()
		if (is_valid_die
			and not is_in_play
			and amount != current_challenge
			and amount<=remaining):
			amount = 0
	remaining-=amount
	dieTime=false
	timer.start()
	return amount

func setRemaining(value:int):
	remaining = value
	
func getChallengeTotal()->int:
	return remaining + in_play() + in_chain()

func set_chained_explosion_count(value:int):
	chained_explosion_count=value

func in_play()->int:
	var sum:int = 0
	for die in get_tree().get_nodes_in_group(Consts.GROUP_DICE):
		if die.name == "DieNode" or die.name.begins_with("@DieNode@"):
			sum += die.value
	return sum
	
func in_play_count()->int:
	var count:int = 0
	for die in get_tree().get_nodes_in_group(Consts.GROUP_DICE):
		if die.name == "DieNode" or die.name.begins_with("@DieNode@"):
			count += 1
	return count

func has_in_play(value:int)->bool:
	for die in get_tree().get_nodes_in_group(Consts.GROUP_DICE):
		if die.name == "DieNode" or die.name.begins_with("@DieNode@"):
			if die.value==value:
				return true
	return false
	
func in_play_set()->Dictionary:
	var dict:Dictionary={}
	for die in get_tree().get_nodes_in_group(Consts.GROUP_DICE):
		if die.name == "DieNode" or die.name.begins_with("@DieNode@"):
			dict[die.value]=die.value
	return dict

func in_chain()->int:
	var sum:int = 0
	for value in chained_explosions:
		sum+=value
	return sum
	
func chain_completed()->bool:
	return (not chained_explosions.empty()) and chained_explosion_count==0

func chain_reset()->void:
	chained_explosion_count=0
	chained_explosions.clear()

func reset(level:int=0)->void:
	rng=RandomNumberGenerator.new()
	rng.seed=level
	remaining=0
	max_die=1
	chain_reset()
	pending_die_faces.clear()
