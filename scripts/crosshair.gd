extends Sprite2D

var child_area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_area = get_child(0) as Area2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == 1 and (event as InputEventMouseButton).pressed:
			var areas = child_area.get_overlapping_areas()
			for area in areas:
				var parent = area.get_parent() as Sprite2D
				var shootable = parent.get_meta("shootable") as bool
				if shootable == true:
					parent.call_deferred("free")
