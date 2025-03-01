extends CharacterBody2D

######################################
# Custom Signals
######################################


######################################
# Preloaded Scenes
######################################


######################################
# Node References
######################################


######################################
# Other Player Variables
######################################


######################################
# Player Check variables
######################################


######################################
# Player State Variables
######################################

func _physics_process(delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 300
	move_and_slide()


func attack(direction):
	
	if direction == Vector2(-1,0):
		pass
	elif direction == Vector2(1,0):
		pass
	elif direction == Vector2(0,-1):
		pass
	elif direction == Vector2(0,1):
		pass
	
