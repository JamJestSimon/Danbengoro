extends Sprite2D

var child_area: Area2D
@export var bullet_chamber: Node
@export var anim_scale: Vector2
@export var anim_trans: Tween.TransitionType
var selected_truth: String
var default_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_area = get_child(0) as Area2D
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	default_scale = self.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()

func set_truth(value: String):
	selected_truth = value

func add_tween():
	if visible: $"../gunshot".play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", anim_scale, 0.1).set_trans(anim_trans)
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "scale", default_scale, 0.1).set_trans(anim_trans)
	await tween2.finished

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == 1 and (event as InputEventMouseButton).pressed:
			add_tween()
			var areas = child_area.get_overlapping_areas()
			for area in areas:
				var parent = area.get_parent() as Sprite2D
				var truth = parent.get_meta("truth") as String
				var shootable = parent.get_meta("shootable") as bool
				if shootable:
					if truth == selected_truth:
						parent.call_deferred("pop_correct")
					else:
						parent.call_deferred("pop_incorrect")
		#bullet aquisition here
		if (event as InputEventMouseButton).button_index == 2 and (event as InputEventMouseButton).pressed:
			add_tween()
			var areas = child_area.get_overlapping_areas()
			for area in areas:
				var parent = area.get_parent() as Sprite2D
				if parent.get_meta("shootable") == true:
					var truth = parent.get_meta("truth_acquisition") as String
					selected_truth = truth
					bullet_chamber.call_deferred("set_special_truth", truth)
