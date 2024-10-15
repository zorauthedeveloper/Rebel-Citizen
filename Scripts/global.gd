extends Node

@onready var headheight = 1.3
@onready var selectedcharacter = 1

@onready var currentclass = "Air"
# Health vars
@onready var health = 50
@onready var health1 = 250
@onready var health2 = 50
@onready var health3 = 250
@onready var health4 = 250
# Stamina vars
@onready var stamina = 100
@onready var stamina1 = 100
@onready var stamina2 = 100
@onready var stamina3 = 100
@onready var stamina4 = 100
# Mana vars
@onready var mana = 100
@onready var mana1 = 100
@onready var mana2 = 100
@onready var mana3 = 100
@onready var mana4 = 100
# Level vars
@onready var level = 0.0
@onready var level1 = 0.0
@onready var level2 = 0.0
@onready var level3 = 0.0
@onready var level4 = 0.0
@onready var globallevel
# Leveldown vars
@onready var leveldown = 0.0
@onready var leveldown1 = 0.0
@onready var leveldown2 = 0.0
@onready var leveldown3 = 0.0
@onready var leveldown4 = 0.0
@onready var globalleveldown

func _process(_delta):
	globallevel = (level1 + level2 + level3 + level4) / 4
	globalleveldown = floor((leveldown1 + leveldown2 + leveldown3 + leveldown4) / 4)

	if selectedcharacter == 1:
		health = health1
		stamina = stamina1
		mana = mana1
		level = level1
		leveldown = leveldown1
	elif selectedcharacter == 2:
		health = health2
		stamina = stamina2
		mana = mana2
		level = level2
		leveldown = leveldown2
	elif selectedcharacter == 3:
		health = health3
		stamina = stamina3
		mana = mana3
		level = level3
		leveldown = leveldown3
	elif selectedcharacter == 4:
		health = health4
		stamina = stamina4
		mana = mana4
		level = level4
		leveldown = leveldown4
	else:
		health = health1
		stamina = stamina1
		mana = mana1
		level = level1
		leveldown = leveldown1
func staminaadd(staminaamount):
	if Global.selectedcharacter == 1:
		Global.stamina1 += staminaamount
	elif Global.selectedcharacter == 2:
		Global.stamina2 += staminaamount
	elif Global.selectedcharacter == 3:
		Global.stamina3 += staminaamount
	elif Global.selectedcharacter == 4:
		Global.stamina4 += staminaamount
		
func healthadd(healthamount):
	if Global.selectedcharacter == 1:
		Global.health1 += healthamount
	elif Global.selectedcharacter == 2:
		Global.health2 += healthamount
	elif Global.selectedcharacter == 3:
		Global.health3 += healthamount
	elif Global.selectedcharacter == 4:
		Global.health4 += healthamount
func manaadd(manaamount):
	if Global.selectedcharacter == 1:
		Global.mana1 += manaamount
	elif Global.selectedcharacter == 2:
		Global.mana2 += manaamount
	elif Global.selectedcharacter == 3:
		Global.mana3 += manaamount
	elif Global.selectedcharacter == 4:
		Global.mana4 += manaamount
