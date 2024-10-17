extends Node3D
@onready var spinnythingy = $CSGMesh3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var positioning : Vector3
var speed : Vector3 = Vector3(0,10,0) 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spinnythingy.rotation_degrees += speed*delta	
	if Global.player.global_position.y < -5: #Reset code for postioning
		Global.healthset(0)
		Global.player.global_position = positioning
	elif Global.player.global_position.y >= 0:
		positioning = Global.player.global_position
