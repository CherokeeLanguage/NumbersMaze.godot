extends Node

class_name Utils

#class names for "is" checks can cause stupid circular loop errors
static func is_type(object:Node, type:String)->bool:
	return object.name == type or object.name.begins_with("@"+type+"@")

static func is_node_visible(node:Node2D)->bool:
	var rect:Rect2=Rect2(0, 0, 1920, 1080)
	return rect.has_point(node.get_global_transform_with_canvas().origin)

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
