extends Node2D

class_name WarpInAreaDetect

onready var raysNode:Node2D=$Rays

var rays:Array = []

func _ready() -> void:
	for child in raysNode.get_children():
		if child is RayCast2D:
			rays.append(child)

func is_empty()->bool:
	var result = __empty()
	queue_free()
	return result
	
func __empty() -> bool:
	
	for ray in rays:
		(ray as RayCast2D).force_raycast_update()
		if (ray as RayCast2D).is_colliding():
			print (str(global_position)+": " + str((ray as RayCast2D).get_collider()))
			return false
	
	return true

