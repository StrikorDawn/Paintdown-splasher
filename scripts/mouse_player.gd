extends Node2D

######################################
# Custom Signals
######################################
signal spawn_enemy(enemy_scene, position)

######################################
# Node References
######################################
@onready var add_currency: Timer = $AddCurrency

######################################
# Enemy Variables
######################################
var enemy_level: int = 1  # Default Level 1 (Glass)
var enemy_colors = ["Red", "Yellow", "Blue"]
var enemy_color_index: int = 0

var enemy_costs = {1: 5, 2: 10, 3: 20}  # Example costs for spawning
var max_currency: int = 50  # Starting currency
var currency: int = 0

var can_add_currency = true

######################################
# Input Handling
######################################
func _process(_delta: float):
	if Input.is_action_just_pressed("spawn"):
		summon_enemy()

	elif Input.is_action_just_pressed("change_level"):
		enemy_level = wrap(enemy_level + 1, 1, 4)  # Loops between 1-3
		print("Selected Enemy Level:", enemy_level)

	elif Input.is_action_just_pressed("next_color"):
		enemy_color_index = (enemy_color_index + 1) % enemy_colors.size()
		print("Selected Color:", enemy_colors[enemy_color_index])

	elif Input.is_action_just_pressed("previous_color"):
		enemy_color_index = (enemy_color_index - 1) % enemy_colors.size()
		print("Selected Color:", enemy_colors[enemy_color_index])
	
	if currency <= max_currency and can_add_currency:
		add_currency.start()
		can_add_currency = false

######################################
# Enemy Spawning
######################################
func summon_enemy():
	var spawn_position = get_global_mouse_position()
	if currency >= enemy_costs[enemy_level]:
		currency -= enemy_costs[enemy_level]
		spawn_enemy.emit(spawn_position, enemy_colors[enemy_color_index], enemy_level)
		print("Spawned:", enemy_colors[enemy_color_index], "Level:", enemy_level, "at", spawn_position)
	else:
		print("Not enough currency!")

func _on_add_currency_timeout() -> void:
	currency += 1
	can_add_currency = true
