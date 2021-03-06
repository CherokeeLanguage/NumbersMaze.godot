extends RigidBody2D

class_name PlayerFireballNode

var DieExplosion:PackedScene = PackedScenes.DieExplosion

onready var animationPlayer:AnimationPlayer = $AnimationPlayer
onready var audioSwoosh:AudioStreamPlayer2D = $Audio_1
onready var audioPoof:AudioStreamPlayer2D = $Audio_2

signal finished

func _ready() -> void:
	mode = MODE_CHARACTER
	audioSwoosh.play(0.15)
	animationPlayer.play("fireball")
	
func transition_to_explode():
	audioSwoosh.stop()
	#linear_velocity=Vector2.ZERO
	linear_damp=-1
	explode()

func explode():		
	audioPoof.play()
	animationPlayer.play("explode")
	apply_central_impulse(Vector2.RIGHT.rotated(rotation).normalized() * 200)

func queue_free():
	emit_signal("finished")	
	.queue_free()

func _on_PlayerFireball_body_entered(body: Node) -> void:
	if Utils.is_type(body, "Player"):
		return
	if body is DieNode:
		(body as DieNode).explode(true)
		queue_free()
		return
	transition_to_explode()

