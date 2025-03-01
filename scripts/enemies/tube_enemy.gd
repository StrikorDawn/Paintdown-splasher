extends EnemyClass
class_name TubeEnemy

func _ready():
	super._ready()
	var sprite_frames = SpriteFrames.new()  # Create an empty animation container

	match color:
		"Red":
			health = 40
			move_speed = 150
			attack_damage = 10
			_load_animation(sprite_frames, "res://assets/sprites/tube/Tube Red.png", "Red")
		"Yellow":
			health = 80
			move_speed = 90
			attack_damage = 20
			_load_animation(sprite_frames, "res://assets/sprites/tube/Tube Yellow.png", "Yellow")

		"Blue":
			health = 60
			move_speed = 110
			attack_damage = 15
			attack_type = "ranged"
			_load_animation(sprite_frames, "res://assets/sprites/tube/Tube Blue.png", "Blue")

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
		var columns = 2  # Number of frames in a row
		var rows = 2  # Number of frames in a column
		var total_frames = 3  # Only using 3 frames out of the 4 available

		var frame_width = texture.get_width() / columns
		var frame_height = texture.get_height() / rows

		sprite_frames.add_animation(anim_name)  # Ensure animation exists before adding frames

		var frame_count = 0
		for y in range(rows):  # Loop through rows
			for x in range(columns):  # Loop through columns
				if frame_count >= total_frames:
					break  # Stop once we've added the required frames

				var frame = AtlasTexture.new()
				frame.atlas = texture
				frame.region = Rect2(x * frame_width, y * frame_height, frame_width, frame_height)
				sprite_frames.add_frame(anim_name, frame)
				
				frame_count += 1

		sprite_frames.set_animation_loop(anim_name, true)  
		sprite_frames.set_animation_speed(anim_name, 10)

		print("Successfully loaded animation:", anim_name)
