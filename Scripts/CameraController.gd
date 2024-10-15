extends Node3D

@onready var player
@export var sens := 5
# Called when the node enters the scene tree for the first time.
func _ready():

	player = get_tree().get_nodes_in_group("Player")[0]
	if Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("jump"):
		$SpringArm3D/Camera3D.look_at(player.get_node("LookAt").global_position)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = player.global_position + Vector3(0,Global.headheight,0)
	
	pass
func _input(event):
	if event is InputEventMouseMotion and !Input.is_action_pressed("moveoff"):
		var tempRot = rotation.x - event.relative.y / 1000 * sens
		rotation.y -= event.relative.x / 1000 * sens
		tempRot = clamp(tempRot, -1, 0.625)
		rotation.x = tempRot
