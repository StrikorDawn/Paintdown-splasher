extends EnemyClass
class_name GlassEnemy

func _ready():
	super._ready()
	var sprite_frames = SpriteFrames.new()  # Create an empty animation container

	match color:
		"Red":
			health = 15
			move_speed = 180
			attack_damage = 5
			_load_animation(sprite_frames, "res://assets/sprites/flask/Flask Red.png", "Red")
		"Yellow":
			health = 30
			move_speed = 120
			attack_damage = 10
			_load_animation(sprite_frames, "res://assets/sprites/flask/Flask Yellow.png", "Yellow")
		"Blue":
			health = 25
			move_speed = 150
			attack_damage = 8
			_load_animation(sprite_frames, "res://assets/sprites/flask/Flask Blue.png", "Blue")
	
	sprite.frames = sprite_frames  # Assign the dynamically created frames
	if sprite_frames.has_animation(color):  # Ensure animation exists before playing
		sprite.play(color)
	else:
		push_error("Animation '" + color + "' does not exist!")

# Function to load the sprite sheet and create animations dynamically
func _load_animation(sprite_frames: SpriteFrames, path: String, anim_name: String):
	if not FileAccess.file_exists(path):
		push_error("Sprite sheet not found: " + path)
		return
	
	var texture = load(path)  # Load the sprite sheet
	if texture:
		var frame_width = texture.get_width() / 3  # Adjust based on columns in the sheet
		var frame_height = texture.get_height()

		sprite_frames.add_animation(anim_name)  # Ensure animation exists before adding frames

		for i in range(3):  # Assuming 3 frames per animation
			var frame = AtlasTexture.new()
			frame.atlas = texture
			frame.region = Rect2(i * frame_width, 0, frame_width, frame_height)
			sprite_frames.add_frame(anim_name, frame)

		sprite_frames.set_animation_loop(anim_name, true)  
		sprite_frames.set_animation_speed(anim_name, 10)
		
		print("Successfully loaded animation:", anim_name)
