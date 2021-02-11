extends EnemyBase

class_name EnemySparklingFireball

func _ready() -> void:
	linear_damp = 30
	pass
	
func _physics_process(delta: float) -> void:
	if not world_path.empty():
		if global_position.distance_to(world_path[0])>16:
			var way_point:Vector2 = Vector2(world_path[0].x, world_path[0].y)
			var rad: = way_point.angle_to_point(global_position)
			var impulse: = Vector2.RIGHT.rotated(rad) * 20
			apply_central_impulse(impulse*delta)
		else:
			world_path.remove(0)
			if not world_path.empty():
				print("next way point: "+str(world_path[0]))

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	pass
	
func _animation_finished(anim_name: String) -> void:
	
	._animation_finished(anim_name)

func _body_entered(body: Node) -> void:
	print(name+"#_body_entered: "+body.name)
	pass # Replace with function body.

func _body_shape_entered(body_id: int, body: Node, body_shape: int, local_shape: int) -> void:
	print(name+"#_body_shape_entered: "+body.name)
	pass # Replace with function body.
