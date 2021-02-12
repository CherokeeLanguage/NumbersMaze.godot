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
	transition_to_explode()
	if body is DieNode:
		body.explode(true)

func explode_for_die()->void:
	audioPoof.play()
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var angle:int = rng.randi()%360
	var direction:Vector2 = Vector2.DOWN.rotated(deg2rad(angle))
	var explosion:DieExplosionNode = DieExplosion.instance()
	explosion.global_position=global_position
	explosion.apply_central_impulse(direction*rng.randf_range(100, 150))
	get_tree().root.call_deferred("add_child", explosion)
	queue_free()

func _playWoosh()->void:
	audioSwoosh.play()
