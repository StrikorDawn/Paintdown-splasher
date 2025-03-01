extends Node2D

@export var object_scene: PackedScene

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_object()

func spawn_object():
	var new_object = object_scene.instantiate()
	new_object.global_position = get_global_mouse_position()
	add_child(new_object)
