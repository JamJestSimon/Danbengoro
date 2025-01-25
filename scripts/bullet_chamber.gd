extends VBoxContainer

@export var truths: Array[String]
var selected_truth: int
const bullet = preload("res://nodes/bullet.tscn")
var bullets: Array[Label]
var special_truth: String = ""

@export var crosshair: Sprite2D

func set_truths(new_truths: Array):
	truths.clear()
	truths.append_array(new_truths)
	for bullet in bullets:
		bullet.call_deferred("free")
	bullets.clear()
	for truth in truths:
		var inst_bullet = bullet.instantiate() as Label
		inst_bullet.text = truth
		self.add_child(inst_bullet)
		bullets.append(inst_bullet)
	selected_truth = 0
	bullets[0].call_deferred("on_selected")
	crosshair.call_deferred("set_truth", truths[selected_truth])

func set_special_truth(value: String):
	if value != "":
		special_truth = value
		bullets[selected_truth].text = special_truth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == 4 and (event as InputEventMouseButton).pressed: #down
		if special_truth != "":
			special_truth = ""
			bullets[selected_truth].text = truths[selected_truth]
		bullets[selected_truth].call_deferred("on_unselected")
		selected_truth = (selected_truth + 1) % bullets.size()
		bullets[selected_truth].call_deferred("on_selected")
		crosshair.call_deferred("set_truth", truths[selected_truth])
	elif event is InputEventMouseButton and (event as InputEventMouseButton).button_index == 5 and (event as InputEventMouseButton).pressed: #up
		if special_truth != "":
			special_truth = ""
			bullets[selected_truth].text = truths[selected_truth]
		bullets[selected_truth].call_deferred("on_unselected")
		selected_truth = (selected_truth - 1) % bullets.size()
		bullets[selected_truth].call_deferred("on_selected")
		crosshair.call_deferred("set_truth", truths[selected_truth])
	self.queue_sort()
