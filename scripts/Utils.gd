extends Node

class_name Utils

static func spaceSep(value:int)->String:
	var tmp = "%09d" % value
	var mod = tmp.length() % 3
	var res = ""

	for i in range(0, tmp.length()):
		if i != 0 && i % 3 == mod:
			res += " "
		res += tmp[i]

	return res

static func shuffle(rng:RandomNumberGenerator, list:Array)->Array:
	var newList:Array = []
	list = list.duplicate()
	while not list.empty():
		var ix=rng.randi_range(0, list.size()-1)
		newList.append(list[ix])
		list.remove(ix)
	return newList
