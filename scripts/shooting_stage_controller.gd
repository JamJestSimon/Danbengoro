extends Node2D

var bubble_node = preload("res://nodes/bubble.tscn")
@export var bullet_chamber: Node
var stage = 0
var bubble = 0
var stages_amount: int
var jsonData = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = FileAccess.open("res://data/shooting_stage_data.json", FileAccess.READ)
	jsonData = JSON.parse_string(data.get_as_text())
	stages_amount = (jsonData["stages"] as Array).size()
	start_stage()
	pass

func start_stage() -> void:
	#show title here
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
	end_stage()
