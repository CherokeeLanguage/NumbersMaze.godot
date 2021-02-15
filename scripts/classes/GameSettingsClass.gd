extends Object

class_name GameSettings

export var folder:String = "user://"

var volume_master:int
var volume_fx:int
var volume_music:int
var tv_zoom:int

var keys:Array = ["volume_master", "volume_fx", "volume_music", "tv_zoom"]

func _init() -> void:
	self.load()

func file()->String:
	return folder+"/global-settings.json"
	
func save()->void:
	var f: = File.new()
# warning-ignore:return_value_discarded
	f.open(file(), File.WRITE)
	f.store_line(to_json(self._dictionary()))
	f.close()
	
func load()->void:
	volume_master = 100
	volume_fx = 75
	volume_music = 10
	tv_zoom = 0
	var f: = File.new()	
	if not f.file_exists(file()):
		save()
		return
# warning-ignore:return_value_discarded
	f.open(file(), File.READ)
	if f.eof_reached():
		f.close()
		push_warning("BLANK SAVE FILE")
		save()
		return
	var json = parse_json(f.get_line())
	f.close()
	if typeof(json) != TYPE_DICTIONARY:
		push_warning("BAD SAVE FILE")
		save()
		return
	for key in json.keys():
		if key in self:
			self[key]=json[key]
			
	volume_master = clamp(volume_master, 0, 100)
	volume_fx = clamp(volume_fx, 0, 100)
	volume_music = clamp(volume_music, 0, 100)
	tv_zoom = clamp(tv_zoom, -15, 15)

func _dictionary() -> Dictionary:
	var d: = Dictionary()
	for key in keys:
		d[key]=self.get(key)
	return d
