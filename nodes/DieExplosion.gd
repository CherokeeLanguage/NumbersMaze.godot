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
	
func finished()->void:
	if is_in_group(Consts.PLAYER_EXPLOSION):
		dieTracker.chained_explosion_count-=1
	queue_free()

func setCollisionDisable(value:bool) -> void:
	if false: 
		collider.set_deferred("disabled", value)

func _on_DieExplosion_body_entered(body: Node) -> void:
	if Utils.is_type(body, "DieNode"):
		body.explode()
