extends Object

class_name GameSlot

export var folder:String = "user://"

var slot:int = 0
var score:int = 0
var level:int = 1
var lives:int = 5

var keys:Array = ["slot", "score", "level", "lives"]

func _init(_slot:int) -> void:
	slot=_slot
	self.load()

func file()->String:
	return folder+"/"+str(slot)+".json"
	
func erase()->void:
	score=0
	level=1
	save()

func save()->void:
	var f: = File.new()
# warning-ignore:return_value_discarded
	f.open(file(), File.WRITE)
	f.store_line(to_json(self._dictionary()))
	f.close()
	
func load()->void:
	var slotLoading = slot
	score=0
	level=1
	lives=5
	var f: = File.new()	
	if not f.file_exists(file()):
		save()
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

	if level<1:
		level = 1
	if score<0:
		score = 0
	slot = slotLoading
	
func _dictionary() -> Dictionary:
	var d: = Dictionary()
	for key in keys:
		d[key]=self.get(key)
	return d

func dump()->void:
	print("slot: "+str(slot))
	print("score: "+str(score))
	print("level: "+str(level))
	print("lives: "+str(lives))

