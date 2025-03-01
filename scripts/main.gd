extends Node

######################################
# Preloaded Scenes
######################################
const GLASS_ENEMY = preload("res://scenes/glass_enemy.tscn")
const TUBE_ENEMY = preload("res://scenes/tube_enemy.tscn")
const BUCKET_ENEMY = preload("res://scenes/bucket_enemy.tscn")

######################################
# Node References
######################################
@onready var mouse_player = $MousePlayer
@onready var player: CharacterBody2D = $Player
@onready var enemy: EnemyClass
######################################
# Setup Signals
######################################
func _ready():
	mouse_player.spawn_enemy.connect(_spawn_enemy)
	player.player_attacking.connect(_player_attack)
	

func _spawn_enemy(position: Vector2, color: String, level: int):
	var enemy
	if level == 1:
		enemy = GLASS_ENEMY.instantiate()
	elif level == 2:
		enemy = TUBE_ENEMY.instantiate()
	elif level == 3:
		enemy = BUCKET_ENEMY.instantiate()
	
	enemy.global_position = position
	enemy.color = color
	enemy.add_to_group("Enemy")
	enemy.enemy_attack.connect(_enemy_attack)
	add_child(enemy)
	
func _player_attack(damage, attack_area):
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):  # Check if it's an enemy
			body.take_damage(damage)  # Call the enemy's damage function

func _enemy_attack(damage, body):
	#if body.is_in_group("Player"):  # Check if it's an enemy
		body.take_damage(damage)  # Call the enemy's damage function
