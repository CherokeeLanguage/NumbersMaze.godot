extends RigidBody2D

enum FACING { NORTH, EAST, SOUTH, WEST}

onready var animation = $AnimationPlayer
onready var cameraFollow = $CameraFollow

var facing = FACING.EAST
var resetPosition:bool = false
var globalPosition:Vector2 = Vector2.ZERO

func setGlobalPosition(pos:Vector2)->void:
	globalPosition=pos
	resetPosition=true

func _ready():
	self.mode=RigidBody2D.MODE_CHARACTER
	self.friction=0
	self.gravity_scale=0
	self.linear_damp=10

func _integrate_forces(state:Physics2DDirectBodyState):
	if resetPosition:
		resetPosition=false
		state.transform.origin=globalPosition
	
func _physics_process(delta):
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
		
		if a>=0 and a<=46 and facing!=FACING.EAST:
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
	else:
		if facing != null:
			match facing:
				FACING.EAST:
					animation.play("idle-east")
				FACING.WEST:
					animation.play("idle-west")
				FACING.NORTH:
					animation.play("idle-north")
				FACING.SOUTH:
					animation.play("idle-south")
			facing = null
					
					
