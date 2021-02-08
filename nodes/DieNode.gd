extends RigidBody2D

class_name DieNode

const ExplosionNode:PackedScene = preload("res://nodes/DieExplosion.tscn")

onready var sprite:Sprite = $Sprite
onready var collider:CollisionShape2D = $CollisionShape2D
onready var dectectorsNode:Node2D = $detectors

var dectectors:Array = []

var mutex:Mutex=Mutex.new()

var d_path: = "res://graphics/dice/d{n}.png"
var value:int=1 setget setValue, getValue
var joint:DampedSpringJoint2D = null setget setJoint

var colors:Array=[]
var valid_die_faces:Array=[1, 2, 3, 4, 5, 6]

func setJoint(value:DampedSpringJoint2D)->void:
	if (value == null):
		sprite.modulate.a=1
	else:
		sprite.modulate.a=0.5
	joint=value
	
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
	for dectector in dectectors:
		if dectector is RayCast2D:
			if dectector.is_colliding():
				var body = dectector.get_collider()
				if body is PlayerFireballNode:
					explode(true)
					break
				if body is DieExplosionNode:
					explode(body.is_in_group(Consts.PLAYER_EXPLOSION))
					break
	
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
	
func getValue()->int:
	return value

func _on_DieNode_body_entered(body: Node) -> void:
	if body is PlayerFireballNode:
		explode(true)
		
	if body is DieExplosionNode:
		explode(body.is_in_group(Consts.PLAYER_EXPLOSION))
		
	if body is TileMap or body.name=="DieNode" or body.name.begins_with("@DieNode@"):
		if Utils.is_node_visible(self):
			sfx.play(sfx.sound.plink)
		return

func explode(player_fireball:bool = false)->void:
	mutex.lock()
	if value==0:
		return
	if Utils.is_node_visible(self):
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
		explosion.apply_central_impulse(direction*rng.randf_range(100, 300))
		if (player_fireball):
			explosion.add_to_group(Consts.PLAYER_EXPLOSION)
			dieTracker.chained_explosion_count+=1
			
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
		value=0
	var parent: = get_parent()
	print("die:_exit_tree: "+name+" of "+parent.name)
