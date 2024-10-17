extends CharacterBody3D

@export var speed = 5.0
@export var crouch_speed = 2.5
@export var acceleration = 5
@export var crouch_height = 1.0
@export var crouch_transition = 8.0
@export var jump = 4.5 #4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lastLookAtDirection : Vector3
var stand_height : float
@onready var lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
@onready var collision_shape = $CollisionShape3D
@onready var top_cast = $TopCast
@onready var avatar = $MeshInstance3D
func _ready():
	stand_height = collision_shape.shape.height
func _physics_process(delta):
	var move_speed = speed
	# Add gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		# Handle jump.
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump
		elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
			move_speed = crouch_speed
			crouch(delta)
		else:
			crouch(delta, true)
	if Input.is_action_pressed("sprint"):
		speed = 8.0
	else:
		speed = 5.0
	# Capture or release mouse based on the "moveoff" action.
	if !Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Get the input direction and handle movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		# If there's input, smoothly rotate toward the lookat target (X and Z axes only)
		if Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("jump"):
			var target_position = Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z)
			
			# Lerp only the X and Z components
			var lerpDirection = Vector3(
				lerp(lastLookAtDirection.x, target_position.x, 0.1),  # Adjust the interpolation factor as needed
				global_position.y,  # Keep Y axis unchanged
				lerp(lastLookAtDirection.z, target_position.z, 0.1)   # Adjust the interpolation factor as needed
			)
			
			look_at(lerpDirection)
			lastLookAtDirection = lerpDirection  # Update for next frame
		
		# Apply movement
		velocity.x = lerp(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * move_speed, acceleration * delta)
	else:
		# Smooth deceleration
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	move_and_slide()

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
