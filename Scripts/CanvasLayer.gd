extends CanvasLayer
var tween : Tween
@onready var menupanel = $Control/Menu/HBoxContainer/Panel
@onready var container = $Control
@onready var healthbar = $Control/HealthHUD/HealthContainer/HealthBar
@onready var levelbar =$Control/LevelHUD/LevelContainerRight/LevelController/Panel2/LevelContainer2/LevelBar
@onready var leveltext = $Control/LevelHUD/LevelContainerLeft/LevelController/Panel/HBoxContainer/LevelText
@onready var levelbackgroundleft = $Control/LevelHUD/LevelContainerLeft/LevelController/Panel/Panel
@onready var levelbackgroundright = $Control/LevelHUD/LevelContainerRight
@onready var healthtext = $Control/HealthHUD/HealthContainer/HealthBar/HealthText
@onready var staminabar = $Control/HealthHUD/StaminaContainer/StaminaBar
@onready var menu_button_1 = $Control/MenuHUD/MenuContainer/MenuButtonController/MenuButton1
@onready var menu_button_2 = $Control/MenuHUD/MenuContainer/MenuButtonController/MenuButton2
@onready var menu_button_3 = $Control/MenuHUD/MenuContainer/MenuButtonController/MenuButton3
var lastsize : Vector2
@onready var level : float = Global.level
var leveldown : float
@onready var health = Global.health
@onready var stamina = Global.stamina
var waittime = 0.1
var healthdown
@onready var maxhealth = Global.maxhealthfunc() #Global.maxhealth
var maxstamina = Global.maxstaminafunc()
var currenthealth
var currentstamina
var healthbar_current_value : float = 0  # For smooth health bar transitions
var levelbar_current_value : float = 0  # For smooth level bar transitions
var staminabar_current_value : float = 0  # For smooth stamina bar transitions
# Variables for the new leveling system
var base_exp = 200  # Base experience multiplier for the formula
var experience : float = 0  # Current experience
var menubuttonamount = 0
var menubuttonheld = false
var menuopened = false
@onready var selectedcharlabel = $Control/HealthHUD/CharacterCardContainer/CharacterCard/Label

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
	maxstamina = Global.maxstamina
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
		Global.health4 = health
	else:
		Global.health1 = health

func update_level():
	level = Global.level
	if level > 250:
		level = 250
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
func increase_modulate():
	var modulate_color = menupanel.modulate
	modulate_color.a = 0.882  # Set alpha to 225 (225/255 = 0.882)
	menupanel.modulate = modulate_color
func decrease_modulate():
	var modulate_color = menupanel.modulate
	modulate_color.a = 0  # Set alpha to 0 (fully transparent)
	menupanel.modulate = modulate_color
func menubuttonpressed():
	# Check if any of the menu buttons are pressed
	if menu_button_1.button_pressed or menu_button_2.button_pressed or menu_button_3.button_pressed or Input.is_action_pressed("menu"):
		menu_button_1.release_focus()
		menu_button_2.release_focus()
		menu_button_3.release_focus()
		if not menubuttonheld:  # Check if the button was not already held
			menubuttonamount += 1
			if menubuttonamount == 1:  # First press opens the menu
				increase_modulate()
				menuopened = true
				Global.menuopened = true
			elif menubuttonamount == 2:  # Second press closes the menu
				decrease_modulate()
				menubuttonamount = 0  # Reset counter for the next open/close cy
				menuopened = false
				Global.menuopened = false
			menubuttonheld = true  # Set the button held flag
	else:
		menubuttonheld = false  # Reset the button held flag when not pressed
func cyclecharacters():
	if Input.is_action_pressed("char1"):
		Global.selectedcharacter = 1
		selectedcharlabel.text = "1"
	elif Input.is_action_pressed("char2"):
		Global.selectedcharacter = 2
		selectedcharlabel.text = "2"
	elif Input.is_action_pressed("char3"):
		Global.selectedcharacter = 3
		selectedcharlabel.text = "3"
	elif Input.is_action_pressed("char4"):
		Global.selectedcharacter = 4
		selectedcharlabel.text = "4"
func _process(delta):
	if !Input.is_action_pressed("moveoff") and menuopened == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif menuopened == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	stamina = Global.stamina
	health = Global.health
	# Increase experience over time (for testing)
	experience += 20000000000000000 * delta  # Gain experience per second
	# Test health increase
	if Global.regenerate == true:
		health = (Global.health + 0.01) + (Global.leveldown / 250)
		stamina = Global.stamina + 0.1 + (Global.leveldown / 2500)

	# Update level and health display
	update_level()
	update_healthbar(health)
	update_stamina(stamina)
	menubuttonpressed()
	cyclecharacters()
	if leveltext.size != lastsize:
		levelbackgroundleft.size = leveltext.size + Vector2(20, 68)
		lastsize = leveltext.size
		levelbackgroundright.position = Vector2(leveltext.size.x/20,0)
