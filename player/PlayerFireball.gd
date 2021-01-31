extends RigidBody2D

class_name PlayerFireballNode

onready var animationPlayer = $AnimationPlayer

signal finished

func _ready() -> void:
	mode = MODE_CHARACTER
	
func transition_to_explode():
	linear_velocity=Vector2.ZERO
	linear_damp=60
	explode()

func fireball():
	animationPlayer.play("fireball")
	
func explode():
	animationPlayer.play("explode")

func queue_free():
	emit_signal("finished")	
	.queue_free()

func _on_PlayerFireball_body_entered(body: Node) -> void:
	if body.name == "Player" or body.name.begins_with("@Player@"):
		return
	transition_to_explode()
