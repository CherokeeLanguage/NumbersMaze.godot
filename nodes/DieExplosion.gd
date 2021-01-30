extends RigidBody2D

class_name DieExplosionNode

signal finished

func _ready() -> void:
	mode = RigidBody2D.MODE_CHARACTER

func finished()->void:
	emit_signal("finished")
	queue_free()
