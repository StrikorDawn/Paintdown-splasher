extends CharacterBody2D
class_name EnemyClass

signal enemy_attack
signal enemy_death

var health: int
var move_speed: int
var attack_damage: int
var color: String
var attack_type: String = "melee"  # "melee" or "ranged"
var can_attack: bool = true

@onready var sprite: AnimatedSprite2D = $CollisionShape2D/Sprite
  # Ensure each enemy scene has a Sprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var hitbox : Area2D = $Hitbox
@onready var hit_sound : AudioStreamPlayer2D = $HitSound
@onready var death_sound : AudioStreamPlayer2D = $DeathSound

func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	print(color + " " + name + " took damage! Health:", health)  # Debugging
	hit_sound.play()
	if health <= 0:
		die()

func die():
	enemy_death.emit(death_sound, global_position, color)
	queue_free()  # Can add effects here

func _on_hitbox_body_entered(body: Node2D) -> void:
	print(body.name)
	enemy_attack.emit(attack_damage, body)
