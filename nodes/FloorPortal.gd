extends Node2D

class_name FloorPortal

signal player_in_portal

func _on_Area2D_body_entered(body: Node) -> void:
	if Utils.is_type(body, "PlayerNode"):
		print("player_in_portal")
		emit_signal("player_in_portal")
