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

######################################
# Player Check variables
######################################
var can_attack : bool = true

######################################
# Other Player Variables
######################################
var health : int = 100
var damage : int = 20
######################################
# Player State Variables
######################################
func _ready() -> void:
	add_to_group("Player")
	attack_area.set_monitoring(false)

func _physics_process(_delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	handle_animation(direction)
	if Input.is_action_just_pressed("attack") and can_attack == true:
		attack(direction)
	
	if health <= 0:
		die()
		
	velocity = direction * 300
	move_and_slide()

func handle_animation(direction):
	if direction == Vector2(-1,0):
		sprite_2d.flip_h = true
		sprite_2d.play("walking")
	elif direction == Vector2(1,0):
		sprite_2d.flip_h = false
		sprite_2d.play("walking")
	elif direction == Vector2(0,-1):
		sprite_2d.play("walking_up")
	elif direction == Vector2(0,1):
		sprite_2d.play("walking")


func attack(direction):
	can_attack = false
	attack_area.set_monitoring(true)
	visual_hitbox.visible = true
	if direction == Vector2(-1,0):
		attack_marker.rotation_degrees = 180
		attack_area.position.x = 40
	elif direction == Vector2(1,0):
		attack_marker.rotation_degrees = 0
		attack_area.position.x = 40
	elif direction == Vector2(0,-1):
		attack_marker.rotation_degrees = 270
		attack_area.position.x = 72
	elif direction == Vector2(0,1):
		attack_marker.rotation_degrees = 90
		attack_area.position.x = 72
	attack_timer.start()

func _on_attack_area_entered(body: Node2D) -> void:
	player_attacking.emit(damage, attack_area)

func _on_attack_timer_timeout() -> void:
	attack_area.set_monitoring(false)
	visual_hitbox.visible = false
	attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func take_damage(damage):
	health -= damage
	print(health)

func die():
	sprite_2d.rotation_degrees = 180
	set_physics_process(false)
