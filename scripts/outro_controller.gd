extends Node2D
@export var speechbox: Label
@export var image_display: TextureRect
@export var image: Texture
var jsonData = []
var line = 0
var lines_total = 0
var reached_end = false

func _ready() -> void:
	var data = FileAccess.open("res://data/outro.json", FileAccess.READ)
	jsonData = JSON.parse_string(data.get_as_text())
	lines_total = jsonData.size()
	next_line()

func next_line() -> void:
	if reached_end:
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	elif line == lines_total:
		speechbox.text = ""
		image_display.texture = image
		reached_end = true
	else:
		var text = jsonData[line]["text"]
		speechbox.text = text
		line += 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == 1 and mouse_event.pressed:
			next_line()
