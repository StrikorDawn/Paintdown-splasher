extends Node2D

######################################
# Custom Signals
######################################
signal spawn_enemy

######################################
# Node References
######################################
@onready var add_currency: Timer = $AddCurrency
@onready var preview_sprite: AnimatedSprite2D = $PreviewSprite  # Using AnimatedSprite2D

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
func _ready():
	if preview_sprite:
		preview_sprite.modulate.a = 0.5  # Semi-transparent preview
	update_preview()  # Set initial preview

func _process(_delta: float):
	if preview_sprite:
		preview_sprite.global_position = get_global_mouse_position()  # Follow mouse
	
	if Input.is_action_just_pressed("spawn"):
		summon_enemy()

	elif Input.is_action_just_pressed("change_level"):
		enemy_level = wrap(enemy_level + 1, 1, 4)  # Loops between 1-3
		update_preview()
		print("Selected Enemy Level:", enemy_level)

	elif Input.is_action_just_pressed("next_color"):
		enemy_color_index = (enemy_color_index + 1) % enemy_colors.size()
		update_preview()
		print("Selected Color:", enemy_colors[enemy_color_index])

	elif Input.is_action_just_pressed("previous_color"):
		enemy_color_index = (enemy_color_index - 1) % enemy_colors.size()
		update_preview()
		print("Selected Color:", enemy_colors[enemy_color_index])
	
	if currency <= max_currency and can_add_currency:
		add_currency.start()
		can_add_currency = false

######################################
# Enemy Preview Update
######################################
func update_preview():
	if not preview_sprite:
		push_error("PreviewSprite node is missing!")
		return
	
	var color = enemy_colors[enemy_color_index]
	var animation_name = ""

	if enemy_level == 1:
		animation_name = "Glass" + color
	elif enemy_level == 2:
		animation_name = "Tube" + color
	elif enemy_level == 3:
		animation_name = "Bucket" + color
	
	if preview_sprite.sprite_frames.has_animation(animation_name):
		preview_sprite.play(animation_name)
		print("Successfully loaded animation:", animation_name)
	else:
		push_error("Animation not found: " + animation_name)

######################################
# Enemy Spawning
######################################
func summon_enemy():
	var spawn_position = get_global_mouse_position()
	if currency >= enemy_costs[enemy_level]:
		# Hide preview briefly to prevent flickering
		if preview_sprite:
			preview_sprite.visible = false

		currency -= enemy_costs[enemy_level]
		spawn_enemy.emit(spawn_position, enemy_colors[enemy_color_index], enemy_level)
		print("Spawned:", enemy_colors[enemy_color_index], "Level:", enemy_level, "at", spawn_position)
		
		# Show preview again after a short delay
		await get_tree().create_timer(0.1).timeout
		if preview_sprite:
			preview_sprite.visible = true
	else:
		print("Not enough currency!")

func _on_add_currency_timeout() -> void:
	currency += 1
	can_add_currency = true
