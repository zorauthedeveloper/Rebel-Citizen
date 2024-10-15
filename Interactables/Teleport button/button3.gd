extends Interactable
var x = 0
@export var position1 := Vector3(0,0,0)
func interact(_body):
	x += 1
	Global.player.global_position = position1
