extends Control

func _ready():
	# Connect buttons using Callable() or lambda function
	$MarginContainer/VBoxContainer/Start.pressed.connect(_on_StartButton_pressed)
	$MarginContainer/VBoxContainer/Quit.pressed.connect(_on_QuitButton_pressed)

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")  

func _on_QuitButton_pressed():
	get_tree().quit()
