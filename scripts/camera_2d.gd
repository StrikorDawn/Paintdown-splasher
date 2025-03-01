extends Camera2D

@export var target: Node2D  # Assign your player node in the inspector
@export var min_limit: Vector2 = Vector2(0, 0)  # Top-left corner of level bounds
@export var max_limit: Vector2 = Vector2(1000, 1000)  # Bottom-right corner of level bounds
@export var smoothing_speed: float = 5.0  # Controls the lag effect

func _ready():
	position_smoothing_enabled = true  # Enable smoothing in case it's disabled

func _process(delta):
	if target:
		# Smoothly move towards the target position
		var target_pos = target.global_position
		global_position = global_position.lerp(target_pos, 1.0 - exp(-smoothing_speed * delta))

		# Clamp the camera position within the set limits
		global_position.x = clamp(global_position.x, min_limit.x, max_limit.x)
		global_position.y = clamp(global_position.y, min_limit.y, max_limit.y)
