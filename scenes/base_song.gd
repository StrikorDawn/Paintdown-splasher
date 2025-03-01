extends AudioStreamPlayer2D

@export var second_song: AudioStream  # Assign a second song in the Inspector

var song_switched = false  # Track if the song has switched

func _on_finished() -> void:
	if not song_switched and second_song:
		stream = second_song
		song_switched = true
		pitch_scale += 0.2
		play()
	else:
		pitch_scale += 0.2
		play()
