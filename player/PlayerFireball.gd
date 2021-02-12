extends RigidBody2D

class_name PlayerFireballNode

var DieExplosion:PackedScene = PackedScenes.DieExplosion

onready var animationPlayer:AnimationPlayer = $AnimationPlayer
onready var audioSwoosh:AudioStreamPlayer = $Audio_1
onready var audioPoof:AudioStreamPlayer = $Audio_2

signal finished

func _ready() -> void:
	mode = MODE_CHARACTER
	
func transition_to_explode():
	audioSwoosh.stop()
	#linear_velocity=Vector2.ZERO
	linear_damp=-1
	explode()

func fireball():
	animationPlayer.play("fireball")
	
func explode():
	animationPlayer.play("explode")
	audioPoof.play()
	apply_central_impulse(Vector2.RIGHT.rotated(rotation).normalized() * 200)

func queue_free():
	emit_signal("finished")	
	.queue_free()

func _on_PlayerFireball_body_entered(body: Node) -> void:
	if Utils.is_type(body, "Player"):
		return
	if body is DieNode:
		body.explode(true)
		queue_free()
		return
	transition_to_explode()

func _playWoosh()->void:
	audioSwoosh.play()
