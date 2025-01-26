extends Node2D

var bubble_node = preload("res://nodes/bubble.tscn")
@export var bullet_chamber: Node
@export var title: Label
@export var speaker: TextureRect
@export var speechbox: RichTextLabel
@export var izmailow: Texture
@export var beniowski: Texture
@export var stieplanow: Texture
@export var riumin: Texture
@export var crosshair: Sprite2D
var stage = 0
var bubble = 0
var player_bubble = 0
var stages_amount: int
var jsonData = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speechbox.visible = false
	var data = FileAccess.open("res://data/shooting_stage_data.json", FileAccess.READ)
	jsonData = JSON.parse_string(data.get_as_text())
	stages_amount = (jsonData["stages"] as Array).size()
	title.modulate = Color(1, 1, 1, 0)
	self.call_deferred("start_stage")
	pass

func start_stage() -> void:
	bullet_chamber.visible = false
	crosshair.visible = false
	title.text = jsonData["stages"][stage]["title"]
	var tween1 = get_tree().create_tween()
	tween1.tween_property(title, "modulate", Color(1, 1, 1 , 1), 0.2)
	await tween1.finished
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(title, "modulate", Color(1, 1, 1 , 0), 0.2)
	await tween2.finished
	bullet_chamber.call_deferred("set_truths", jsonData["stages"][stage]["bullets"])
	restart_stage()
	pass

func restart_stage() -> void:
	bubble = 0
	crosshair.visible = true
	bullet_chamber.visible = true
	spawn_bubble()

func spawn_bubble() -> void:
	speaker.visible = true
	var bubbles = jsonData["stages"][stage]["bubbles"] as Array
	var startPos = Vector2(bubbles[bubble]["start_position"]["x"] as float, bubbles[bubble]["start_position"]["y"] as float)
	var bubble_inst = bubble_node.instantiate()
	add_child(bubble_inst)
	bubble_inst.call_deferred("set_start_pos", startPos)
	bubble_inst.call_deferred("set_text", bubbles[bubble]["text"])
	bubble_inst.call_deferred("set_truth", bubbles[bubble]["truth"])
	bubble_inst.call_deferred("set_route", bubbles[bubble]["route"])
	bubble_inst.call_deferred("set_time", bubbles[bubble]["time"] as float)
	bubble_inst.call_deferred("set_shootable", bubbles[bubble]["shootable"] as bool)
	bubble_inst.call_deferred("set_truth_acquisition", bubbles[bubble]["truth_acquisition"])
	bubble_inst.call_deferred("set_audio", bubbles[bubble]["id"])
	match bubbles[bubble]["character"]:
		"B":
			speaker.texture = beniowski
		"I":
			speaker.texture = izmailow
		"S":
			speaker.texture = stieplanow
		"R":
			speaker.texture = riumin

func spawn_player_bubble() -> void:
	var bubbles = jsonData["stages"][stage]["end_bubbles"] as Array
	var bubble_inst = bubble_node.instantiate()
	add_child(bubble_inst)
	bubble_inst.call_deferred("set_start_pos", Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2))
	bubble_inst.call_deferred("set_text", bubbles[player_bubble]["text"])
	bubble_inst.call_deferred("set_time", bubbles[player_bubble]["time"] as float)
	bubble_inst.call_deferred("set_player")

func next_bubble() -> void:
	bubble += 1
	if(bubble >= (jsonData["stages"][stage]["bubbles"] as Array).size()):
		#anims here
		speechbox.visible = true
		for dialogue in jsonData["stages"][stage]["restart_dialogue"]:
			match dialogue["character"]:
				"B":
					speaker.texture = beniowski
				"I":
					speaker.texture = izmailow
				"S":
					speaker.texture = stieplanow
				"R":
					speaker.texture = riumin
			speechbox.text = "[center]%s[/center]" % dialogue["text"]
			await get_tree().create_timer(dialogue["time"] as float).timeout
		speechbox.visible = false
		restart_stage()
	else:
		spawn_bubble()

func next_player_bubble():
	player_bubble += 1
	if(player_bubble >= (jsonData["stages"][stage]["end_bubbles"] as Array).size()):
		end_stage()
	else:
		spawn_player_bubble()
	pass

func end_stage() -> void:
	stage += 1
	if stage == stages_amount:
		print_debug("Game finished")
	else:
		start_stage()

func on_incorrect_bubble_destoryed() -> void:
	#anims here
	crosshair.visible = false
	speechbox.visible = true
	for dialogue in jsonData["stages"][stage]["incorrect_dialogue"]:
		match dialogue["character"]:
			"B":
				speaker.texture = beniowski
			"I":
				speaker.texture = izmailow
			"S":
				speaker.texture = stieplanow
			"R":
				speaker.texture = riumin
		speechbox.text = "[center]%s[/center]" % dialogue["text"]
		await get_tree().create_timer(dialogue["time"] as float).timeout
	speechbox.visible = false
	restart_stage()

func on_correct_bubble_destoryed() -> void:
	player_bubble = 0
	spawn_player_bubble()

var isTimeScaleChanged : bool = false
func _input(event):
	if event.is_action_pressed("SpeedUp") and !isTimeScaleChanged:
		Engine.time_scale = 5.
		get_tree().call_group(&"Bubble", &"changeSpeed", Engine.time_scale)
		isTimeScaleChanged = true
		return
	elif event.is_action_released("SpeedUp") and isTimeScaleChanged:
		Engine.time_scale = 1.
		isTimeScaleChanged = false
		get_tree().call_group(&"Bubble", &"changeSpeed", Engine.time_scale)
		return
	
	if event.is_action_pressed("SlowDown") and !isTimeScaleChanged:
		Engine.time_scale = 0.2
		isTimeScaleChanged = true
		get_tree().call_group(&"Bubble", &"changeSpeed", Engine.time_scale)
		return
	elif event.is_action_released("SlowDown") and isTimeScaleChanged:
		Engine.time_scale = 1.
		isTimeScaleChanged = false
		get_tree().call_group(&"Bubble", &"changeSpeed", Engine.time_scale)
		return
