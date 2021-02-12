extends EnemyBase

class_name EnemySparklingFireball

const DieExplosion:PackedScene = PackedScenes.DieExplosion

var exploded:bool = false

func _ready() -> void:
	linear_damp = 10
	gravity_scale = 0.1
	pass
	
func _physics_process(delta: float) -> void:
	if not world_path.empty():
		if global_position.distance_to(world_path[0])>32:
			var way_point:Vector2 = Vector2(world_path[0].x, world_path[0].y)
			var rad: = way_point.angle_to_point(global_position)
			var impulse: = Vector2.RIGHT.rotated(rad).normalized() * 5000
			apply_central_impulse(impulse*delta)
		else:
			world_path.remove(0)
			if not world_path.empty():
				print("next way point: "+str(world_path[0]))

#func _integrate_forces(state: Physics2DDirectBodyState) -> void:
#	pass
	
func _animation_finished(anim_name: String) -> void:
	
	._animation_finished(anim_name)

func _body_entered(body: Node) -> void:
	print(name+"#_body_entered: "+body.name)
	explode_check(body)

func _body_shape_entered(_body_id: int, body: Node, body_shape: int, _local_shape: int) -> void:
	print(name+"#_body_shape_entered: "+body.name)
	explode_check(body)

func explode_check(body:Node)->void:
	mutex.lock()
	if exploded:
		return	
	if not body is TileMap:
		explode()
	mutex.unlock()
	
func explode()->void:
	exploded=true
	if Utils.is_node_visible(self):
		sfx.play(sfx.sound.explode)
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	for angle in range(0, 360, 45):
		var direction:Vector2 = Vector2.DOWN.rotated(deg2rad(angle))
		var explosion:DieExplosionNode = DieExplosion.instance()
		explosion.global_position=global_position
		explosion.apply_central_impulse(direction*rng.randf_range(100, 150))
		get_tree().root.call_deferred("add_child", explosion)
	queue_free()

