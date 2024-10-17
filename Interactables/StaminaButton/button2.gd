extends Interactable
var x = 0

func interact(_body):
	x += 1
	Global.staminaadd(10)
