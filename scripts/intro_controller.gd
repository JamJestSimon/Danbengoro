extends Node2D
@export var speechbox: RichTextLabel
@export var speaker: TextureRect
@export var beniowski: Texture
@export var izmailow: Texture
@export var stieplanow: Texture
@export var riumin: Texture
var jsonData = {}
var line = 0
var lines_total = 0

func _ready() -> void:
	var data = FileAccess.open("res://data/intro.json", FileAccess.READ)
	jsonData = JSON.parse_string(data.get_as_text())
	lines_total = (jsonData["lines"] as Array).size()
	next_line()

func next_line() -> void:
	if line == lines_total:
		changeToNextScene()
	else:
		var selected_image = jsonData["lines"][line]["image"]
		speaker.visible = true
		match selected_image:
			"B":
				speaker.texture = beniowski
			"I":
				speaker.texture = izmailow
			"S":
				speaker.texture = stieplanow
			"R":
				speaker.texture = riumin
			"":
				speaker.visible = false
		var text = jsonData["lines"][line]["text"]
		speechbox.text = "[center]%s[/center]" % text
		line += 1

func changeToNextScene():
	get_tree().change_scene_to_file("res://scenes/shooting_stage.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == 1 and mouse_event.pressed:
			next_line()
	elif event.is_action_pressed("Pause"):
		changeToNextScene()
