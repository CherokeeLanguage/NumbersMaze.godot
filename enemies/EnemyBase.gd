extends RigidBody2D

class_name EnemyBase

export var hit_points:int = 1

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

var rays:Array = []
var world_path:PoolVector2Array = PoolVector2Array() setget set_world_path
var mutex:Mutex=Mutex.new()

func _ready() -> void:
	setRayRotations()

"""
Ensures the rays are pointing the in the directios
needed for direct array indexing for directions.
"""
func setRayRotations()->void:
	var angle:int = 0
	for ray in $Rays.get_children():
		if ray is RayCast2D:
			ray.rotation_degrees=angle
			angle+=45
			rays.append(ray)

#func ray_colliders()->Array:
#	var colliders:Array=[]
#	for ray in rays:
#		if ray is RayCast2D:
#			if ray.is_colliding():
#				var collider = ray.get_collider()
#				if collider is RigidBody2D:
#					colliders.append(collider)
#	return colliders

#func ray_down()->Array:
#	return ray_ix(0)
#
#func ray_left()->Array:
#	return ray_ix(2)
#
#func ray_up()->Array:
#	return ray_ix(4)
#
#func ray_right()->Array:
#	return ray_ix(6)

#func ray_ix(ix:int)->Object:
#	var ray: = rays[ix] as RayCast2D
#	if ray.is_colliding():
#		return ray.get_collider()
#	return null

func set_world_path(value:PoolVector2Array):
	world_path=value
	print("New path: ")
	for way_point in world_path:
		print(" - "+str(way_point))

func _animation_finished(_anim_name: String) -> void:
	queue_free()
