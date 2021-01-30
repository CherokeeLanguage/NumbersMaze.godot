extends Control

class_name BaseMenu

signal main_menu

func _connect(sig:String, target:Object, method:String, binds: Array=[], flags: int =0) -> void:
	if not has_signal(sig):
		return
	var _x = .connect(sig, target, method, binds, flags)

func _physics_process(_delta):
	if Input.is_action_just_pressed("btn_select"):
		emit_signal("main_menu")
