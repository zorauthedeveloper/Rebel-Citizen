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

# Get the gravity from the project settings to be synced with RigidBody nodes.
var old_vel : float = 0.0
var hurt_tween : Tween
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lastLookAtDirection : Vector3
var stand_height : float

# Dash state
var is_dashing = false
var dash_time_left = 0.0
var dash_cooldown_time = 0.0
var dash_direction = Vector3()

# Crouching state
var is_crouching = false

@onready var lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
@onready var collision_shape = $CollisionShape3D
@onready var top_cast = $TopCast
@onready var avatar = $MeshInstance3D
@onready var hurt_overlay = $HBoxContainer/HurtOverlay


func _ready():
	stand_height = collision_shape.shape.height

func _physics_process(delta):
	var move_speed = speed
	
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump
		# Crouch logic
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
	
	# Handle dash cooldown
	if dash_cooldown_time > 0:
		dash_cooldown_time -= delta
	
	# Handle dashing

	# Movement input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Always rotate towards the lookat target during movement and dashing
	if direction:
		if Input.is_action_just_pressed("dash") and dash_cooldown_time <= 0 and not is_crouching and Global.stamina > 35:
			is_dashing = true
			Global.staminaadd(-35)
			dash_time_left = dash_duration
			dash_cooldown_time = dash_cooldown
			# Dash direction based on movement input (X axis, reduced Y axis)
			dash_direction = velocity.normalized()
			dash_direction.y *= dash_y_axis_factor  # Reduce Y influence
	
		var target_position = Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z)
		
		# Lerp only the X and Z components for smoother rotation
		var lerpDirection = Vector3(
			lerp(lastLookAtDirection.x, target_position.x, 0.1),
			global_position.y,
			lerp(lastLookAtDirection.z, target_position.z, 0.1)
		)
		
		look_at(lerpDirection)
		lastLookAtDirection = lerpDirection

	# If dashing, apply dash velocity
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false  # End dash when time is up
		else:
			velocity.x = lerp(velocity.x, dash_direction.x * dash_speed, dash_lerp_factor)
			velocity.z = lerp(velocity.z, dash_direction.z * dash_speed, dash_lerp_factor)
			move_and_slide()
			# Continue updating look direction during dash
	else:
		# Apply movement
		velocity.x = lerp(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * move_speed, acceleration * delta)
	
	# Smooth deceleration when no input
	if direction == Vector3.ZERO and not is_dashing:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	move_and_slide()

	# Capture or release mouse based on the "moveoff" action
	if !Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if old_vel < 0:
		var diff = velocity.y - old_vel
		if diff > 15:
			hurt()
			print("Hurt")
	old_vel = velocity.y
func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	# Smoothly interpolate collision shape height.
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	# Update collision shape position based on the new height.
	collision_shape.position.y = collision_shape.shape.height * 0.5
	# Scale the avatar to match the height change smoothly.
	avatar.scale.y = target_height / stand_height
	avatar.position.y = target_height * 0.5
	# Adjust head height if necessary.
	if not reverse:
		Global.headheight = lerp(Global.headheight, target_height - 0.5, crouch_transition * delta)
	else:
		Global.headheight = lerp(Global.headheight, target_height, crouch_transition * delta)
func hurt():
	hurt_overlay.modulate = Color.WHITE
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	hurt_tween.tween_property(hurt_overlay, "modulate", Color.TRANSPARENT, 0.5)
	Global.healthadd(-20)
