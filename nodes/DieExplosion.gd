extends RigidBody2D

class_name DieExplosionNode

onready var collider:CollisionShape2D=$CollisionShape2D

func _ready() -> void:
	var pm:PhysicsMaterial = PhysicsMaterial.new()
	
	pm.absorbent=false
	pm.bounce=1
	pm.friction=0
	pm.rough=false
	
	self.physics_material_override = pm

func disableCollider()->void:
	collider.disabled=true
	
func enableCollider()->void:
	collider.disabled=false
	
func setColliderRadius(size:float)->void:
	var shape: = collider.shape as CircleShape2D
	if (shape!=null):
		shape.set_deferred("radius", size)
	
func finished()->void:
	if is_in_group(Consts.PLAYER_EXPLOSION):
		dieTracker.chained_explosion_count-=1
	queue_free()

