extends CharacterBody3D

@export var speed = 5.0
@export var crouch_speed = 2.5
@export var acceleration = 5
@export var crouch_height = 1.0
@export var crouch_transition = 8.0
@export var jump = 4.5

@export var dash_speed = 15.0
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0
@export var dash_lerp_factor = 0.5  # Lerp factor for dash smoothing
@export var dash_y_axis_factor = 0.2  # Reduce Y-axis influence during dash

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lastLookAtDirection : Vector3
var stand_height : float

var is_dashing = false
var dash_time_left = 0.0
var dash_cooldown_time = 0.0
var dash_direction = Vector3()

var is_crouching = false

@onready var lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
@onready var collision_shape = $CollisionShape3D
@onready var top_cast = $TopCast
@onready var avatar = $MeshInstance3D

func _ready():
	stand_height = collision_shape.shape.height

func _physics_process(delta):
	var move_speed = speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump
		elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
			move_speed = crouch_speed
			is_crouching = true
			crouch(delta)
		else:
			is_crouching = false
			crouch(delta, true)

	# Sprint
	if Input.is_action_pressed("sprint"):
		speed = 8.0
	else:
		speed = 5.0
	
	# Dash cooldown
	if dash_cooldown_time > 0:
		dash_cooldown_time -= delta

	# Movement input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Get angular velocity from the platform
	if is_on_floor():
		var platform_angular_velocity = get_platform_angular_velocity()
		velocity += platform_angular_velocity * delta

	if direction:
		if Input.is_action_just_pressed("dash") and dash_cooldown_time <= 0 and not is_crouching and Global.stamina > 35:
			is_dashing = true
			Global.staminaadd(-35)
			dash_time_left = dash_duration
			dash_cooldown_time = dash_cooldown
			dash_direction = velocity.normalized()
			dash_direction.y *= dash_y_axis_factor
	
		var target_position = Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z)
		
		var lerpDirection = Vector3(
			lerp(lastLookAtDirection.x, target_position.x, 0.1),
			global_position.y,
			lerp(lastLookAtDirection.z, target_position.z, 0.1)
		)
		
		look_at(lerpDirection)
		lastLookAtDirection = lerpDirection

	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
		else:
			velocity.x = lerp(velocity.x, dash_direction.x * dash_speed, dash_lerp_factor)
			velocity.z = lerp(velocity.z, dash_direction.z * dash_speed, dash_lerp_factor)
			move_and_slide()
	else:
		velocity.x = lerp(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * move_speed, acceleration * delta)

	if direction == Vector3.ZERO and not is_dashing:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	move_and_slide()

	if !Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = collision_shape.shape.height * 0.5
	avatar.scale.y = target_height / stand_height
	avatar.position.y = target_height * 0.5
	if not reverse:
		Global.headheight = lerp(Global.headheight, target_height - 0.5, crouch_transition * delta)
	else:
		Global.headheight = lerp(Global.headheight, target_height, crouch_transition * delta)
