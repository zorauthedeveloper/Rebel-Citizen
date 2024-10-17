extends Interactable
var x = 0
@export var stamina_amount := 20
func interact(_body):
	Global.staminaadd(stamina_amount)
	
