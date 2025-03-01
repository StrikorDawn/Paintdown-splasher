extends CharacterBody2D

######################################
# Custom Signals
######################################


######################################
# Node References
######################################
@onready var attack_marker: Marker2D = $AttackMarker
@onready var attack_area: Area2D = $AttackMarker/AttackArea
@onready var visual_hitbox: Sprite2D = $"AttackMarker/AttackArea/AttackCollision/Visual Hitbox"
@onready var attack_timer: Timer = $AttackTimer

######################################
# Player Check variables
######################################
var can_attack : bool = true

######################################
# Other Player Variables
######################################

######################################
# Player State Variables
######################################

func _physics_process(delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("attack") and can_attack == true:
		attack(direction)
		
	velocity = direction * 300
	move_and_slide()


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
	

func _on_attack_timer_timeout() -> void:
	can_attack = true
	attack_area.set_monitoring(false)
	visual_hitbox.visible = false
