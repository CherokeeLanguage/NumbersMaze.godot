extends RigidBody2D

class_name PlayerNode

enum FACING { NORTH, EAST, SOUTH, WEST}

const FireballNode:PackedScene = preload("res://player/PlayerFireball.tscn")

onready var animation:AnimationPlayer = $AnimationPlayer
onready var cameraFollow:RemoteTransform2D = $CameraFollow
onready var raysNode:Node2D = $Rays
onready var fbTimer:Timer=$FireBallTimer
onready var collider:CollisionShape2D = $CollisionShape2D
onready var sprite:Sprite = $Sprite

var facing = FACING.EAST
var idle:bool = false
var resetPosition:bool = false
var globalPosition:Vector2 = Vector2.ZERO
var rays:Array = []
var items:Array = []
var fireball_enabled:bool = true

func setGlobalPosition(pos:Vector2)->void:
	globalPosition=pos
	resetPosition=true
	
func reset_stats()->void:
	pass

func _ready():
	
	for ray in raysNode.get_children():
		if ray is RayCast2D:
			rays.append(ray)
	
	self.mode=RigidBody2D.MODE_CHARACTER
	
	self.gravity_scale=0
	self.linear_damp=10
	
	var pm:PhysicsMaterial = PhysicsMaterial.new()
	
	pm.absorbent=false
	pm.bounce=0
	pm.friction=0
	pm.rough=false
	
	self.physics_material_override = pm

func _integrate_forces(state:Physics2DDirectBodyState):
	if resetPosition:
		resetPosition=false
		state.transform.origin=globalPosition
	
func _physics_process(delta):
	move_check(delta)
	pickup_check()
	drop_check()
	fireball_check()

func fireball_check():
	if Input.is_action_just_pressed("btn_a") and fireball_enabled:
		var fireball:PlayerFireballNode = FireballNode.instance()
		add_child(fireball)
		var impulse:Vector2 = Vector2.RIGHT
		var myRotation:float = 0.0
		match facing:
			FACING.EAST:
				impulse = Vector2.RIGHT
				myRotation = 0
			FACING.SOUTH:
				impulse = Vector2.DOWN
				myRotation = 90
			FACING.WEST:
				impulse = Vector2.LEFT
				myRotation = 180
			FACING.NORTH:
				impulse = Vector2.UP
				myRotation = 270
			
		fireball.apply_impulse(Vector2.ZERO, impulse*1000)
		fireball.rotation_degrees=myRotation
		fireball.global_position = global_position
		match facing:
			FACING.NORTH:
				fireball.global_position.y -= 48
			FACING.SOUTH:
				fireball.global_position.y += 48
			FACING.EAST:
				fireball.global_position.x += 32
				fireball.global_position.y += 8
			FACING.WEST:
				fireball.global_position.x -= 32
				fireball.global_position.y += 8
		
		fireball_enabled=false
		fbTimer.stop()
		fbTimer.start(0.35)
		
func drop_check():
	if Input.is_action_just_pressed("btn_y"):
		for item in items:
			if item is DieNode:
				item.joint.queue_free()
				item.joint=null
		items.clear()

func pickup_check()->void:
	if Input.is_action_just_pressed("btn_x"):
		var theItem:DieNode=null
		var distance:float=-1
		for ray in rays:
			if ray.is_colliding():
				print("ray.is_colliding")
				var item:DieNode = (ray.get_collider() as DieNode)
				if item!=null:
					if item.joint!=null:
						continue
					var item_distance:float = item.global_position.distance_to(self.global_position)
					if item_distance < distance or distance<0:
						theItem = item

		if theItem!=null:
			var joint:DampedSpringJoint2D = DampedSpringJoint2D.new()
			add_child(joint)
			joint.stiffness=10
			joint.rest_length=64
			joint.length=32
			joint.node_a = get_path()
			joint.node_b = theItem.get_path()
			theItem.joint = joint
			
			items.append(theItem)
			
func move_check(delta:float)->void:
	var impulse: = Vector2.ZERO
	if Input.is_action_pressed("right"):
		impulse.x=1
	if Input.is_action_pressed("left"):
		impulse.x=-1
	if Input.is_action_pressed("up"):
		impulse.y=-1
	if Input.is_action_pressed("down"):
		impulse.y=1
	if impulse.length()>0:
		apply_central_impulse(impulse.normalized()*4000*delta)
		var a = wrapf(rad2deg(impulse.angle()), 0, 360)
		
		"""
		E: 0
		SE: 45
		S: 90
		SW: 135
		W: 180
		NW: 225
		N: 270
		NE: 315		
		"""
		if idle:
			facing = null
		if a>=0 and a<=45 and facing!=FACING.EAST:
			facing = FACING.EAST
			animation.play("east")
		if a>=315 and facing!=FACING.EAST:
			facing = FACING.EAST
			animation.play("east")
		if a>=135 and a<=225 and facing!=FACING.WEST:
			facing = FACING.WEST
			animation.play("west")
		if a>225 and a<315 and facing!=FACING.NORTH:
			facing = FACING.NORTH
			animation.play("north")
		if a>45 and a<135 and facing!=FACING.SOUTH:
			facing = FACING.SOUTH
			animation.play("south")
		idle = false
	else:
		if not idle:
			idle = true
			match facing:
				FACING.EAST:
					animation.play("idle-east")
				FACING.WEST:
					animation.play("idle-west")
				FACING.NORTH:
					animation.play("idle-north")
				FACING.SOUTH:
					animation.play("idle-south")
					
					


func _on_FireBallTimer_timeout() -> void:
	fireball_enabled = true
