extends CollisionShape2D

func _ready() -> void:
	print("_ready")
	pass # Replace with function body.

func set_disabled(value:bool)->void:
	print("set_disabled")
	call_deferred(".set_disabled", value)
