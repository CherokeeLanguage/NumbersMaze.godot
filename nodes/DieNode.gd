extends RigidBody2D

class_name DieNode

var ExplosionNode:PackedScene = PackedScenes.DieExplosion

onready var sprite:Sprite = $Sprite
onready var collider:CollisionShape2D = $CollisionShape2D
onready var dectectorsNode:Node2D = $detectors
onready var sfx: = $SoundFx

var dectectors:Array = []

var mutex:Mutex=Mutex.new()

var d_path: = "res://graphics/dice/d{n}.png"
var value:int=1 setget setValue, getValue
var joint:DampedSpringJoint2D = null setget setJoint

var colors:Array=[]
var valid_die_faces:Array=[1, 2, 3, 4, 5, 6]

func setJoint(_value:DampedSpringJoint2D)->void:
	if (_value == null):
		sprite.modulate.a=1
	else:
		sprite.modulate.a=0.4
	joint=_value
	
func _ready() -> void:
	setupColorsArray()
	for child in dectectorsNode.get_children():
		if child is RayCast2D:
			dectectors.append(child)
	set_die_face()
	
func setupColorsArray()->void:
	colors.clear()
	colors.append(Color.coral)
	colors.append(Color.lightsalmon)
	colors.append(Color.palegoldenrod)
	colors.append(Color.lightgreen)
	colors.append(Color.mediumaquamarine)
	colors.append(Color.turquoise)
	colors.append(Color.powderblue)
	colors.append(Color.skyblue)
	colors.append(Color.violet)
	return
			
func _physics_process(_delta: float) -> void:
#	for dectector in dectectors:
#		if dectector is RayCast2D:
#			if dectector.is_colliding():
#				var body = dectector.get_collider()
#				if body is PlayerFireballNode:
#					explode(true)
#					break
#				if body is DieExplosionNode:
#					explode(body.is_in_group(Consts.PLAYER_EXPLOSION))
#					break
#				if body is EnemyBase:
#					explode(false)
	pass
	
func set_die_face()->void:
	if not is_instance_valid(sprite):
		push_warning("Die face sprite is not valid")
		return
	var texture:Texture = load(d_path.replace("{n}", str(value)))
	sprite.texture=texture
	var size:Vector2 = sprite.texture.get_size() * sprite.scale
	var shape:RectangleShape2D = RectangleShape2D.new()
	shape.extents.x = size.x/2
	shape.extents.y = size.y/2
	collider.shape=shape
	if value in valid_die_faces:
		var color:int = valid_die_faces.find(value)
		if color>-1:
			sprite.modulate=colors[color]

func setValue(_value:int)->void:
	value = _value
	set_die_face()
	set_physics_attributes()
	
func set_physics_attributes()->void:
	var pm: = PhysicsMaterial.new()
	pm.friction = 1
	pm.rough = false
	pm.bounce = 0.0001
	pm.absorbent = false
	physics_material_override=pm

	linear_damp = 1
	mass = 0.5
	gravity_scale = 1
	
func getValue()->int:
	return value

func _on_body_entered(body: Node) -> void:
	if Utils.is_type(body, "PlayerFireballNode"):
		explode(true)
		return
		
	if body is DieExplosionNode:
		explode(body.is_in_group(Consts.PLAYER_EXPLOSION))
		return
		
	if body is TileMap or Utils.is_type(body, "DieNode"):
		sfx.effect(Consts.fx.plink)
		return

func explode(player_fireball:bool = false)->void:
	mutex.lock()
	if value==0:
		return
	sfx.effect(Consts.fx.explode, true)
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	for _ix in range(value+1):
		var x:int = rng.randi_range(-1, 1)
		var y:int = rng.randi_range(-1, 1)
		var direction:Vector2 = Vector2(x, y).normalized()
		var explosion:DieExplosionNode = ExplosionNode.instance()
		explosion.global_position=global_position
		explosion.apply_central_impulse(direction*rng.randf_range(100, 200))
		if (player_fireball):
			explosion.add_to_group(Consts.PLAYER_EXPLOSION)
			dieTracker.chained_explosion_count+=1
		get_tree().root.call_deferred("add_child", explosion)
			
	if player_fireball:
		dieTracker.chained_explosions.append(value)
	else:
		dieTracker.remaining+=value
		
	dieTracker.resetDieTime()
	value=0
	mutex.unlock()
	queue_free()

func _exit_tree() -> void:
	if value>0:
		dieTracker.remaining+=value
		var parent: = get_parent()
		print("die:_exit_tree: "+name+" of "+parent.name)
		value=0

func _on_Area2D_body_entered(body: Node) -> void:
	_on_body_entered(body)


func _on_DieNode_body_entered(body: Node) -> void:
	_on_body_entered(body)
