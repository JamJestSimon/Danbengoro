extends Node
# Ten skrypt działa ZAWSZE

func _input(event):
	if event.is_action_pressed("ToggleFullscreen"):
		var isFullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED if isFullscreen 
			else DisplayServer.WINDOW_MODE_FULLSCREEN)
