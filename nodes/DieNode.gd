extends RigidBody2D

class_name DieNode

signal exploding

const ExplosionNode:PackedScene = preload("res://nodes/DieExplosion.tscn")

onready var sprite:Sprite = $Sprite
onready var collider:CollisionShape2D = $CollisionShape2D

var d_path: = "res://graphics/dice/d{n}.png"
var value:int=1 setget setValue, getValue
var joint:DampedSpringJoint2D = null

func _ready() -> void:
	set_die_face()
	
func set_die_face()->void:
	if not is_instance_valid(sprite):
		push_warning("Die face sprite is not valid")
		return
	var texture:Texture = load(d_path.replace("{n}", str(value)))
	sprite.texture=texture
	var size:Vector2 = sprite.texture.get_size()
	var shape:RectangleShape2D = RectangleShape2D.new()
	shape.extents.x = size.x/2
	shape.extents.y = size.y/2
	collider.shape=shape

func setValue(_value:int)->void:
	value = _value
	set_die_face()
	
func getValue()->int:
	return value

func _on_DieNode_body_entered(body: Node) -> void:
	if body is PlayerFireballNode or body is DieExplosionNode:
		explode()
		queue_free()
	if body is TileMap:
		sfx.play(sfx.sound.plink)
		return

func explode()->void:
	sfx.play(sfx.sound.explode)
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	for _ix in range(value+1):
		var x:int = rng.randi_range(-1, 1)
		var y:int = rng.randi_range(-1, 1)
		var direction:Vector2 = Vector2(x, y).normalized()
		var explosion:DieExplosionNode = ExplosionNode.instance()
		get_tree().root.add_child(explosion)
		explosion.global_position=global_position
		explosion.apply_central_impulse(direction*rng.randf_range(500, 1000))
	
