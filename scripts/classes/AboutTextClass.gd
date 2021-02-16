extends Object

class_name AboutTextClass

export var folder:String = "res://text"

var text:String = ""

func _init() -> void:
	self.load()

func load()->void:
	append_file("info.txt")
	append_file("attributions.txt")
	append_file("changelog.txt")

func append_file(file:String)->void:
	file = folder + "/" + file
	var f: = File.new()	
	if not f.file_exists(file):
		push_warning("MISSING TEXT FILE: "+file)
		return
# warning-ignore:return_value_discarded
	f.open(file, File.READ)
	if f.eof_reached():
		f.close()
		push_warning("BLANK TEXT FILE: "+file)
		return
	var tmp = f.get_as_text()
	f.close()

	text += tmp
	text += "\n\n"
	
	while text.ends_with("\n\n\n"):
		text = text.substr(0, text.length()-1)
