#extends Object

class_name GameSlot

export var folder:String = "user://"

var slot:int = 0
var score:int = 0
var level:int = 0

var keys:Array = ["slot", "score", "level"]

func file()->String:
	return folder+"/"+str(slot)+".json"

func saveJson()->void:
	var f: = File.new()
# warning-ignore:return_value_discarded
	f.open(file(), File.WRITE)
	f.store_line(to_json(self._dictionary()))
	f.close()
	
func loadJson()->void:
	var f: = File.new()	
	if not f.file_exists(file()):
		return
# warning-ignore:return_value_discarded
	f.open(file(), File.READ)
	if f.eof_reached():
		f.close()
		push_warning("BLANK SAVE FILE")
		return
	var json = parse_json(f.get_line())
	f.close()
	if typeof(json) != TYPE_DICTIONARY:
		push_warning("BAD SAVE FILE")
		return
	for key in json.keys():
		if key in self:
			self[key]=json[key]

func _dictionary() -> Dictionary:
	var d: = Dictionary()
	for key in keys:
		print(key)
		d[key]=self.get(key)
	return d

func dump()->void:
	print("slot: "+str(slot))
	print("level: "+str(level))
	print("score: "+str(score))

