extends CanvasLayer

class_name FadeOutIn

onready var animationPlayer = $AnimationPlayer

signal transition_mid
signal transition_end

func fade()->void:
	animationPlayer.play("fade")
	
func transition_mid()->void:
	emit_signal("transition_mid")

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("transition_end")
	queue_free()
