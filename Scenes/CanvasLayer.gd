extends CanvasLayer

@onready var container = $Control
@onready var healthbar = $Control/HealthHUD/HealthBar
@onready var levelbar = $Control/HealthHUD/Control/LevelBar
@onready var leveltext = $Control/HealthHUD/Control/LevelBackground/LevelText
@onready var levelbackground = $Control/HealthHUD/Control/LevelBackground
@onready var healthtext = $Control/HealthHUD/HealthBar/HealthText

var lastsize : Vector2
@onready var level : float = Global.level
var leveldown : float
@onready var health = Global.health
var healthdown
var maxhealth = 250
var currenthealth
var healthbar_current_value : float = 0  # For smooth health bar transitions
var levelbar_current_value : float = 0  # For smooth level bar transitions

# Variables for exponential level difficulty
var base_exp = 100  # Base experience required for the first level
var exp_growth_rate = 1.2  # Experience growth rate per level
var experience : float = 0  # Current experience

func _ready():
	experience += 100
	level = 0
	# Set the max value of the ProgressBars to 10000 (scaled)
	healthbar.max_value = 10000
	levelbar.max_value = 10000  # Level bar uses the same scale as the health bar
	update_healthbar(50)

# Function to calculate required experience for the next level
func exp_for_next_level(level):
	return base_exp * pow(exp_growth_rate, level)

func update_healthbar(health):
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
	
	# Get required experience for next level
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
	
	#Update level
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
	# Increase experience over time (for testing)
	experience += 20000000000000000 * delta  # Gain experience per second
	# Test health increase
	health += 0.01
	
	# Update level and health display
	update_level()
	update_healthbar(health)
	
	if leveltext.size != lastsize:
		levelbackground.size = leveltext.size + Vector2(20, 0)
		lastsize = leveltext.size
		levelbar.global_position = Vector2(levelbackground.size.x + 315,0) + Vector2(0,855)
	
	# Get the size of the viewport
	var viewport_size = get_viewport().get_visible_rect().size
	# Set the size of the container to match the viewport
	container.size = viewport_size
