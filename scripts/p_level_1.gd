extends Node2D


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		var current_mode = get_window().mode
		if current_mode == Window.MODE_WINDOWED:
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED
