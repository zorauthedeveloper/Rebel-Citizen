extends Node3D
@onready var spinnythingy = $CSGMesh3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var speed : Vector3 = Vector3(0,10,0) 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spinnythingy.rotation_degrees += speed*delta	
