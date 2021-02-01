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

func _ready() -> void:
	rng=RandomNumberGenerator.new()
	rng.seed=1
	timer.wait_time=0.125
	timer.one_shot=true
	timer.autostart=false
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "on_Timer_timeout")
	timer.start()
	
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
	
func isDieTime()->bool:
	if not dieTime:
		return false
	if remaining<1:
		return false
	var inplay:int = in_play()
	if inplay < max_die:
		return true
	if inplay > max_die*2:
		return false
	if chained_explosion_count>0:
		dieTime=false
		timer.start()
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
func nextDie():
	var amount:int = 0
	while (amount>max_die or amount==0 or amount>remaining):
		amount = Utils.shuffle(rng, valid_die_faces)[0]
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