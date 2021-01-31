extends RigidBody2D

class_name DieNode

const ExplosionNode:PackedScene = preload("res://nodes/DieExplosion.tscn")

onready var sprite:Sprite = $Sprite
onready var collider:CollisionShape2D = $CollisionShape2D

var d_path: = "res://graphics/dice/d{n}.png"
var value:int=1 setget setValue, getValue
var joint:DampedSpringJoint2D = null
var audio_enabled:bool = true

func _ready() -> void:
	set_die_face()
	var rect:Rect2=Rect2(0, 0, 1920, 1080)
	audio_enabled=rect.has_point(get_global_transform_with_canvas().origin)
	
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
	if body is PlayerFireballNode:
		explode(true)		
		
	if body is DieExplosionNode:
		explode(body.is_in_group(Consts.PLAYER_EXPLOSION))
		
	if body is TileMap or body.name=="DieNode" or body.name.begins_with("@DieNode@"):
		if audio_enabled:
			sfx.play(sfx.sound.plink)
		return

func explode(player_fireball:bool = false)->void:
	if (audio_enabled):
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
		if (player_fireball):
			explosion.add_to_group(Consts.PLAYER_EXPLOSION)
			dieTracker.chained_explosion_count+=1
	if player_fireball:
		dieTracker.chained_explosions.append(value)
	else:
		dieTracker.remaining+=value
	dieTracker.resetDieTime()
	queue_free()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	audio_enabled=true

func _on_VisibilityNotifier2D_screen_exited() -> void:
	audio_enabled=false
