extends Node

######################################
# Preloaded Scenes
######################################
const GLASS_ENEMY = preload("res://scenes/glass_enemy.tscn")
const TUBE_ENEMY = preload("res://scenes/tube_enemy.tscn")
const BUCKET_ENEMY = preload("res://scenes/bucket_enemy.tscn")
const big_blue = preload("res://assets/sprites/Blue Splat 1.png")
const big_red = preload("res://assets/sprites/Red Splat 1.png")
const big_yellow = preload("res://assets/sprites/Yellow Splat 1.png")

######################################
# Node References
######################################
@onready var mouse_player: Node2D = $MousePlayer
@onready var player: CharacterBody2D = $Player
@onready var enemy: EnemyClass
@onready var death_player: AudioStreamPlayer2D = $death_noise
<<<<<<< HEAD
@onready var canvas_layer: CanvasLayer = $CanvasLayer
=======

>>>>>>> 26641cbd9045af37bb8eff5bc83c6444b415da1c
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
	enemy.enemy_death.connect(_enemy_killed)
	add_child(enemy)
	return
	
func _player_attack(damage, attack_area):
	var bodies = attack_area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("Enemy"):  # Check if it's an enemy
			body.take_damage(damage)  # Call the enemy's damage function

func _enemy_attack(damage, body):
	if body.is_in_group("Player"):  # Check if it's an enemy
		body.take_damage(damage)  # Call the enemy's damage function

func _enemy_killed(sound, position, color):
	var dying_noise = sound.stream
	death_player.stream = dying_noise
	if color == "Blue":
		var splatter = Sprite2D.new()
		splatter.texture = big_blue
		splatter.global_position = position
		splatter.scale = Vector2(0.75, 0.75) 
		splatter.rotation_degrees = randf_range(0, 360)
		canvas_layer.add_child(splatter)
	if color == "Red":
		var splatter = Sprite2D.new()
		splatter.texture = big_red
		splatter.global_position = position
		splatter.scale = Vector2(0.75, 0.75)
		splatter.rotation_degrees = randf_range(0, 360)
		canvas_layer.add_child(splatter)
	if color == "Yellow":
		var splatter = Sprite2D.new()
		splatter.texture = big_yellow
		splatter.global_position = position
		splatter.scale = Vector2(randf_range(0.25, 1.5), randf_range(0.25, 1.5))
		splatter.rotation_degrees = randf_range(0, 360)
		canvas_layer.add_child(splatter)
	death_player.play()
