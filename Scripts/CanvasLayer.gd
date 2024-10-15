extends CanvasLayer

@onready var container = $Control
@onready var healthbar = $Control/HealthHUD/HealthContainer/HealthBar
@onready var levelbar =$Control/LevelHUD/LevelContainerRight/LevelController/Panel2/LevelContainer2/LevelBar
@onready var leveltext = $Control/LevelHUD/LevelContainerLeft/LevelController/Panel/HBoxContainer/LevelText
@onready var levelbackgroundleft = $Control/LevelHUD/LevelContainerLeft/LevelController/Panel/Panel
@onready var levelbackgroundright = $Control/LevelHUD/LevelContainerRight
@onready var healthtext = $Control/HealthHUD/HealthContainer/HealthBar/HealthText
@onready var staminabar = $Control/HealthHUD/StaminaContainer/StaminaBar
var lastsize : Vector2
@onready var level : float = Global.level
var leveldown : float
@onready var health = Global.health
@onready var stamina = Global.stamina
var waittime = 0.1
var healthdown
@onready var maxhealth = Global.maxhealth
var maxstamina = 100
var currenthealth
var currentstamina
var healthbar_current_value : float = 0  # For smooth health bar transitions
var levelbar_current_value : float = 0  # For smooth level bar transitions
var staminabar_current_value : float = 0  # For smooth stamina bar transitions
# Variables for the new leveling system
var base_exp = 200  # Base experience multiplier for the formula
var experience : float = 0  # Current experience

func _ready():
	experience += 100
	level = 0
	# Set the max value of the ProgressBars to 10000 (scaled)
	healthbar.max_value = 10000
	levelbar.max_value = 10000  # Level bar uses the same scale as the health bar
	update_healthbar(50)

# Function to calculate required experience for the next level using the formula 200(1/2z^2 - 1/2z + 1)
func exp_for_next_level(level):
	return base_exp * ((0.5 * level * level) - (0.5 * level) + 1)

func update_stamina(stamina):
	if stamina > maxstamina:
		stamina = maxstamina
	if stamina < 0:
		stamina = 0
	currentstamina = float(stamina) / float(maxstamina) * 100
	#staminabar_current_value = lerp(staminabar_current_value, currentstamina, 0.1)
	staminabar.value = currentstamina #staminabar_current_value

	# Sync stamina with the selected character's stamina
	if Global.selectedcharacter == 1:
		Global.stamina1 = stamina
	elif Global.selectedcharacter == 2:
		Global.stamina2 = stamina
	elif Global.selectedcharacter == 3:
		Global.stamina3 = stamina
	elif Global.selectedcharacter == 4:
		Global.stamina4 = stamina

func update_healthbar(health):
	maxhealth = Global.maxhealth
	if health > maxhealth:
		health = maxhealth
	if health < 0:
		health = 0
	healthdown = floor(health)
	# Cast health and maxhealth to float to avoid integer division
	currenthealth = float(health) / float(maxhealth) * 10000
	var healthbartext = str(healthdown) + "/" + str(maxhealth)
	healthtext.text = healthbartext
	# Smooth transition for health bar
	healthbar_current_value = lerp(healthbar_current_value, currenthealth, 0.1)  # Smooth interpolation
	healthbar.value = healthbar_current_value
	if Global.selectedcharacter == 1:
		Global.health1 = health
	elif Global.selectedcharacter == 2:
		Global.health2 = health
	elif Global.selectedcharacter == 3:
		Global.health3 = health
	elif Global.selectedcharacter == 4:
		Global.health2 = health
	else:
		Global.health1 = health

func update_level():
	if level > 100:
		level = 100
	if level < 0:
		level = 0
	leveldown = floor(level)
	leveltext.text = "Lv. " + str(leveldown)
	
	# Get required experience for next level using the new equation
	var required_exp = exp_for_next_level(leveldown)
	
	# Calculate level bar progress based on current experience
	var levelbarprogress = (experience / required_exp) * 10000
	
	# Smooth transition for level bar
	levelbar_current_value = lerp(levelbar_current_value, levelbarprogress, 0.1)  # Smooth interpolation
	levelbar.value = levelbar_current_value
	
	# Check if player has enough experience to level up
	if experience >= required_exp:
		level += 1  # Level up
		experience -= required_exp  # Subtract the required experience (carry over any extra experience)
	
	# Update level in Global variables
	if Global.selectedcharacter == 1:
		Global.level1 = level
	elif Global.selectedcharacter == 2:
		Global.level2 = level
	elif Global.selectedcharacter == 3:
		Global.level3 = level
	elif Global.selectedcharacter == 4:
		Global.level4 = level
	else:
		Global.level1 = level
	
	if Global.selectedcharacter == 1:
		Global.leveldown1 = leveldown
	elif Global.selectedcharacter == 2:
		Global.leveldown2 = leveldown
	elif Global.selectedcharacter == 3:
		Global.leveldown3 = leveldown
	elif Global.selectedcharacter == 4:
		Global.leveldown4 = leveldown
	else:
		Global.leveldown1 = leveldown

func _process(delta):
	stamina = Global.stamina
	health = Global.health
	# Increase experience over time (for testing)
	experience += 200 * delta  # Gain experience per second
	# Test health increase
	health = Global.health + 0.01 
	stamina = Global.stamina + 0.1
	# Update level and health display
	update_level()
	update_healthbar(health)
	update_stamina(stamina)
	if leveltext.size != lastsize:
		levelbackgroundleft.size = leveltext.size + Vector2(20, 68)
		lastsize = leveltext.size
		levelbackgroundright.position = Vector2(leveltext.size.x/20,0)
