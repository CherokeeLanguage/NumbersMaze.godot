extends Node

class_name Challenges

const challengeSplit:int = 6;

var challengeMax:int = 0
var challengeMin:int = 0
var challengeList:Array = []
var challengeTotalValue:int = 0

func _init(level:int, maxChallenge:int=999):
	var challengeLevel:int = level - 1
	var challengeSet:int = challengeLevel / challengeSplit + 1
	var subSet:int = challengeLevel % challengeSplit
	var _range:int = 7
	var start:int = (challengeSet-1)*_range+1
	var end:int = start + _range
	var _seed:Array=[]
	
	if end>maxChallenge:
		_range *= 2
		end = (end * level) % 1000
		if end<_range+1:
			end=_range+1
		start = end - _range
		print("=== Challenge wrap! New range: "+str(start)+"-"+str(end))
	
	for ix in range (start, end):
		_seed.append(ix)
	if start > _range:
		for ix in range(start-_range, end-_range):
			_seed.append(ix)
	else:
		for ix in range(start, end):
			_seed.append(ix)
	
	if level>1000:
		var rng:RandomNumberGenerator = RandomNumberGenerator.new()
		rng.seed=level
		for ix in range(_seed.size()):
			_seed[ix] = rng.randi_range(1, maxChallenge)
	
	var iQueue:IntervalQueue = IntervalQueue.new()
	var list: = iQueue.getQueueFor(_seed)
	var split:int = list.size() / challengeSplit
	var setStart:int = split * subSet
	var nextSet:int = split * (subSet+1)
	for ix in range (setStart, nextSet):
		challengeList.append(list[ix])
	challengeTotalValue=0
	for value in challengeList:
		challengeTotalValue += value
		if challengeMax<value or challengeMax==0:
			challengeMax=value
		if challengeMin>value or challengeMin==0:
			challengeMin=value

class IntervalQueue:
	
	func _init():
		pass
	
	func getQueueFor(startingEntries:Array) -> Array:
		var offsets:Array=[]
		var newQueue:Array=[]
		var samples:Array=[]
		
		offsets = getOffsets()
		samples.append_array(startingEntries)
		
		# process samples creating non-random work queue
		
		for ix in range(0, samples.size()):
			var ia:int = 0
			for iy in range(0, offsets.size()):
				while newQueue.size() < ia + 1:
					newQueue.append(0)
				while newQueue[ia] != 0:
					ia+=1
					while newQueue.size() < ia + 1:
						newQueue.append(0)
				newQueue[ia]=samples[ix]
				ia += offsets[iy]
		
		removeGaps(newQueue)
		
		return newQueue
		
	func removeGaps(queue:Array):
		var current:int=0
		
		for _repeat in range(0, 10):
			var prev:int = 0
			var vx1:Array=[]
			var vx2:Array=[]
			var hasDupes:bool=false
			for ix in range(0,queue.size()):
				if queue[ix]==0:
					continue
				current = queue[ix]
				if current != prev:
					vx1.append(current)
					prev=current
				else:
					vx2.append(current)
					hasDupes=true
			queue.clear()
			queue.append_array(vx1)
			queue.append_array(vx2)
			if not hasDupes:
				break
		
	func getOffsets(briefList:bool=true)->Array:
		var o1:Array=[]
		var depth:int=6
		var stagger:int=2
		var basePower:int=2
		
		if briefList:
			depth = 5
			stagger = 1
			basePower = 3
		
		for ix in range(0, stagger):
			for ip in range(0, depth):
				o1.append(int(pow(basePower + ix, ip)))
				
		return o1
	
