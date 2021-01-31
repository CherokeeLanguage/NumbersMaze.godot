extends RigidBody2D

class_name DieExplosionNode

func _ready() -> void:
	mode = RigidBody2D.MODE_CHARACTER
	linear_damp=0.02
	mass=0.1
	
func finished()->void:
	if is_in_group(Consts.PLAYER_EXPLOSION):
		dieTracker.chained_explosion_count-=1
	queue_free()

