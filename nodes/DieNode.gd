extends RigidBody2D

class_name DieNode

onready var sprite:Sprite = $Sprite
onready var collider:CollisionShape2D = $CollisionShape2D

var d_path: = "res://graphics/dice/d{n}.png"
var value:int=1 setget setValue, getValue
var joint:DampedSpringJoint2D = null

func _ready() -> void:
	set_die_face()
	
func set_die_face()->void:
	#print_debug(d_path.replace("{n}", str(value)))
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
