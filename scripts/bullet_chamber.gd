extends VBoxContainer

@export var truths: Array[String]
var selected_truth: int
const bullet = preload("res://nodes/bullet.tscn")
var bullets: Array[Label]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for truth in truths:
		var inst_bullet = bullet.instantiate() as Label
		inst_bullet.text = truth
		self.add_child(inst_bullet)
		bullets.append(inst_bullet)
	selected_truth = 0
	bullets[0].scale = Vector2(1.5, 1.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == 4: #up
		bullets[selected_truth].scale = Vector2(1, 1)
		selected_truth = (selected_truth + 1) % bullets.size()
		bullets[selected_truth].scale = Vector2(1.5, 1.5)
	elif event is InputEventMouseButton and (event as InputEventMouseButton).button_index == 5: #up
		bullets[selected_truth].scale = Vector2(1, 1)
		selected_truth = (selected_truth - 1) % bullets.size()
		bullets[selected_truth].scale = Vector2(1.5, 1.5)
