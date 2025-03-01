extends EnemyClass
class_name GlassEnemy

@onready var player = get_node("/root/Main/Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100
	move_and_slide()
