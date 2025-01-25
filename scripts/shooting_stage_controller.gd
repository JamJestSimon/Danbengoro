extends Node2D

var bubble_node = preload("res://nodes/bubble.tscn")
@export var bullet_chamber: Node
@export var title: Label
@export var speaker: Sprite2D
@export var speechbox: RichTextLabel
var stage = 0
var bubble = 0
var player_bubble = 0
var stages_amount: int
var jsonData = {}
var stage_finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = FileAccess.open("res://data/shooting_stage_data.json", FileAccess.READ)
	jsonData = JSON.parse_string(data.get_as_text())
	stages_amount = (jsonData["stages"] as Array).size()
	title.modulate = Color(1, 1, 1, 0)
	self.call_deferred("start_stage")
	pass

func start_stage() -> void:
	title.text = jsonData["stages"][stage]["title"]
	var tween1 = get_tree().create_tween()
	tween1.tween_property(title, "modulate", Color(1, 1, 1 , 1), 1.0)
	await tween1.finished
	var timer = get_tree().create_timer(5.0)
	await timer.timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(title, "modulate", Color(1, 1, 1 , 0), 1.0)
	await tween2.finished
	bullet_chamber.call_deferred("set_truths", jsonData["stages"][stage]["bullets"])
	restart_stage()
	pass

func restart_stage() -> void:
	bubble = 0
	spawn_bubble()

func spawn_bubble() -> void:
	var bubbles = jsonData["stages"][stage]["bubbles"] as Array
	var startPos = Vector2(bubbles[bubble]["start_position"]["x"], bubbles[bubble]["start_position"]["y"])
	var bubble_inst = bubble_node.instantiate()
	add_child(bubble_inst)
	bubble_inst.call_deferred("set_start_pos", startPos)
	bubble_inst.call_deferred("set_text", bubbles[bubble]["text"])
	bubble_inst.call_deferred("set_truth", bubbles[bubble]["truth"])
	bubble_inst.call_deferred("set_route", bubbles[bubble]["route"])
	bubble_inst.call_deferred("set_time", bubbles[bubble]["time"])
	bubble_inst.call_deferred("set_shootable", bubbles[bubble]["shootable"])

func next_bubble() -> void:
	bubble += 1
	if(bubble >= (jsonData["stages"][stage]["bubbles"] as Array).size()):
		#dialogue here
		restart_stage()
	else:
		spawn_bubble()

func next_player_bubble():
	player_bubble += 1
	if(player_bubble >= (jsonData["stages"][stage]["bubbles"] as Array).size()):
		end_stage()
	else:
		spawn_bubble()
	pass

func end_stage() -> void:
	stage += 1
	if stage == stages_amount:
		print_debug("Game finished")
	else:
		start_stage()

func on_incorrect_bubble_destoryed() -> void:
	#dialogue here
	restart_stage()

func on_correct_bubble_destoryed() -> void:
	#player monologue here
	player_bubble = 0
