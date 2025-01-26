extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	
	if event.is_action_pressed("Pause") and is_equal_approx(1., Engine.time_scale):
		togglePause()

func _on_resume_button_down():
	togglePause()

func togglePause():
	var newPauseVal: bool = not get_tree().paused
	get_tree().paused = newPauseVal
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if newPauseVal else Input.MOUSE_MODE_HIDDEN)
	visible = newPauseVal

func _on_to_menu_button_down():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
