extends Node

@onready var headheight = 1.3
@onready var selectedcharacter = 1
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var currentclass = "Air"
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
# Health vars
@onready var health = 250
@onready var health1 = 250
@onready var health2 = 250
@onready var health3 = 250
@onready var health4 = 250
# Health vars
@onready var maxhealth = 250 + 250 * (leveldown)
@onready var maxhealth1 = 250 + 250 * (leveldown1)
@onready var maxhealth2 = 250 + 250 * (leveldown2)
@onready var maxhealth3 = 250 + 250 * (leveldown3)
@onready var maxhealth4 = 250 + 250 * (leveldown4)
# Stamina vars
@onready var stamina = 100
@onready var stamina1 = 100
@onready var stamina2 = 100
@onready var stamina3 = 100
@onready var stamina4 = 100
# Stamina vars
@onready var maxstamina = 100 + ((leveldown)/250)*200 
@onready var maxstamina1 = 100 + ((leveldown1)/250)*200 
@onready var maxstamina2 = 100 + ((leveldown2)/250)*200 
@onready var maxstamina3 = 100 + ((leveldown3)/250)*200 
@onready var maxstamina4 = 100 + ((leveldown4)/250)*200 
# Mana vars
@onready var mana = 100
@onready var mana1 = 100
@onready var mana2 = 100
@onready var mana3 = 100
@onready var mana4 = 100

var regenerate = true
var menuopened = false
func _process(_delta):
	globallevel = (level1 + level2 + level3 + level4) / 4
	globalleveldown = floor((leveldown1 + leveldown2 + leveldown3 + leveldown4) / 4)
	maxhealth = 250 + 250 * (leveldown)
	maxhealth1 = 250 + 250 * (leveldown1)
	maxhealth2 = 250 + 250 * (leveldown2)
	maxhealth3 = 250 + 250 * (leveldown3)
	maxhealth4 = 250 + 250 * (leveldown4)
	maxstamina = 100 + ((leveldown)/250)*200 
	maxstamina1 = 100 + ((leveldown1)/250)*200 
	maxstamina2 = 100 + ((leveldown2)/250)*200 
	maxstamina3 = 100 + ((leveldown3)/250)*200 
	maxstamina4 = 100 + ((leveldown4)/250)*200 
	if selectedcharacter == 1:
		health = health1
		stamina = stamina1
		mana = mana1
		level = level1
		leveldown = leveldown1
		maxhealth = maxhealth1
	elif selectedcharacter == 2:
		health = health2
		stamina = stamina2
		mana = mana2
		level = level2
		leveldown = leveldown2
		maxhealth = maxhealth2
	elif selectedcharacter == 3:
		health = health3
		stamina = stamina3
		mana = mana3
		level = level3
		leveldown = leveldown3
		maxhealth = maxhealth3
	elif selectedcharacter == 4:
		health = health4
		stamina = stamina4
		mana = mana4
		level = level4
		leveldown = leveldown
		maxhealth = maxhealth4
	else:
		health = health1
		stamina = stamina1
		mana = mana1
		level = level1
		leveldown = leveldown1
		maxhealth = maxhealth1
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
func healthset(healthamount):
	if Global.selectedcharacter == 1:
		Global.health1 = healthamount
	elif Global.selectedcharacter == 2:
		Global.health2 = healthamount
	elif Global.selectedcharacter == 3:
		Global.health3 = healthamount
	elif Global.selectedcharacter == 4:
		Global.health4 = healthamount
func manaadd(manaamount):
	if Global.selectedcharacter == 1:
		Global.mana1 += manaamount
	elif Global.selectedcharacter == 2:
		Global.mana2 += manaamount
	elif Global.selectedcharacter == 3:
		Global.mana3 += manaamount
	elif Global.selectedcharacter == 4:
		Global.mana4 += manaamount
func maxhealthfunc():
	if Global.selectedcharacter == 1:
		Global.maxhealth = maxhealth1
	elif Global.selectedcharacter == 2:
		Global.maxhealth = maxhealth2
	elif Global.selectedcharacter == 3:
		Global.maxhealth = maxhealth3
	elif Global.selectedcharacter == 4:
		Global.maxhealth = maxhealth
	return maxhealth
func maxstaminafunc():
	if Global.selectedcharacter == 1:
		Global.maxstamina = maxstamina
	elif Global.selectedcharacter == 2:
		Global.maxstamina = maxstamina
	elif Global.selectedcharacter == 3:
		Global.maxstamina = maxstamina
	elif Global.selectedcharacter == 4:
		Global.maxstamina = maxstamina
	return maxstamina
