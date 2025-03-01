extends CharacterBody2D

######################################
# Custom Signals
######################################
signal player_attacking

######################################
# Node References
######################################
@onready var sprite_2d: AnimatedSprite2D = $PlayerCollision/Sprite2D
@onready var attack_marker: Marker2D = $AttackMarker
@onready var attack_area: Area2D = $AttackMarker/AttackArea
@onready var visual_hitbox: Sprite2D = $"AttackMarker/AttackArea/AttackCollision/Visual Hitbox"
@onready var attack_timer: Timer = $AttackLengthTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

######################################
# Player Check Variables
######################################
var can_attack: bool = true
var attack_buffered: bool = false  # Stores attack input during cooldown

######################################
# Other Player Variables
######################################
var health: int = 100
var damage: int = 20
var last_direction: Vector2 = Vector2(1, 0)  # Default facing right

######################################
# Player State Functions
######################################
func _ready() -> void:
	add_to_group("Player")
	attack_area.set_monitoring(false)

func _physics_process(_delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	handle_animation(direction)

	if direction != Vector2.ZERO:
		last_direction = direction

	# Handle attack input with buffering
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			attack()
		else:
			attack_buffered = true  # Store input for later use

	if health <= 0:
		die()

	velocity = direction * 300
	move_and_slide()

func handle_animation(direction: Vector2):
	if direction.x < 0:
		sprite_2d.flip_h = true
		sprite_2d.play("walking")
	elif direction.x > 0:
		sprite_2d.flip_h = false
		sprite_2d.play("walking")
	elif direction.y < 0:
		sprite_2d.play("walking_up")
	elif direction.y > 0:
		sprite_2d.play("walking")
	else:
		# Maintain facing direction when idle
		if last_direction.y < 0:
			sprite_2d.play("idle_up")
		else:
			sprite_2d.play("idle")

func attack():
	can_attack = false
	attack_buffered = false  # Clear buffer when attacking
	attack_area.set_monitoring(true)
	visual_hitbox.visible = true

	# Use last direction for attack rotation
	if last_direction == Vector2(-1, 0):  # Left
		attack_marker.rotation_degrees = 180
		attack_area.position.x = 40
	elif last_direction == Vector2(1, 0):  # Right
		attack_marker.rotation_degrees = 0
		attack_area.position.x = 40
	elif last_direction == Vector2(0, -1):  # Up
		attack_marker.rotation_degrees = 270
		attack_area.position.x = 72
	elif last_direction == Vector2(0, 1):  # Down
		attack_marker.rotation_degrees = 90
		attack_area.position.x = 72

	animation_player.play("swing")
	attack_timer.start()

func _on_attack_area_entered(body: Node2D) -> void:
	player_attacking.emit(damage, attack_area)

func _on_attack_timer_timeout() -> void:
	attack_area.set_monitoring(false)
	visual_hitbox.visible = false
	attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
	if attack_buffered:  # If attack was buffered, execute it immediately
		attack()

func take_damage(damage: int):
	health -= damage
	print(health)

func die():
	sprite_2d.rotation_degrees = 180
	set_physics_process(false)
	
