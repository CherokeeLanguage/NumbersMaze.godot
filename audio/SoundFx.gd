extends AudioStreamPlayer2D

class_name SoundFx

func _ready() -> void:
	bus = "Fx"
	pitch_scale = 1

func effect(effect:String, _new:bool=false) -> void:
	if _new:
		var sfx:SoundFx = PackedScenes.SoundFx.instance()
		get_tree().root.add_child(sfx)
		sfx.global_position=global_position
		sfx.stream=consts.effect(effect)
# warning-ignore:return_value_discarded
		sfx.connect("finished", sfx, "queue_free")		
		sfx.play()
	else:
		stream=consts.effect(effect)
		play()
