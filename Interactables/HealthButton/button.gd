extends Interactable
var x = 0
@export var healthamount := 20
func interact(_body):
	Global.healthadd(healthamount*Global.leveldown)
	
