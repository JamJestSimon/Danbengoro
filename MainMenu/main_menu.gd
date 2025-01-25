extends Control

@export
var gameScene: PackedScene

func _on_start_button_down():
	get_tree().change_scene_to_packed(gameScene)

func _on_quit_button_down():
	get_tree().quit()
