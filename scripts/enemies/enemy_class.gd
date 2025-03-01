extends CharacterBody2D
class_name EnemyClass

<<<<<<< HEAD
signal enemy_attack

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
func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	print(color + " " + name + " took damage! Health:", health)  # Debugging
	if health <= 0:
		die()

func die():
	queue_free()  # Can add effects here

func _on_hitbox_body_entered(body: Node2D) -> void:
	print(body.name)
	enemy_attack.emit(attack_damage, body)
=======
var health : int
var move_speed : int
var size : float
var color
var level : int
>>>>>>> de4ebec32aac8e93d2760d49e537626b9461ee55
