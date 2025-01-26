extends Control

@export
var gameScene: PackedScene

@export var credits: CanvasLayer

func _ready():
	credits.visible = false

func _on_start_button_down():
	get_tree().change_scene_to_packed(gameScene)

func _on_quit_button_down():
	get_tree().quit()


func _on_credits_butt_button_down():
	credits.visible = true
	get_node("%CreditsButt").release_focus()

func _on_credits_butt_2_button_down():
	credits.visible = false
