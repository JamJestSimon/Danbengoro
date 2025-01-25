extends Label

@export var selected_scale: Vector2 = Vector2(1,1)
@export var time: float = 0.1
@export var transition_type: Tween.TransitionType

var target: Control
var default_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = self as Control
	default_size = target.size
	self.custom_minimum_size = default_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_selected() -> void:
	add_tween("custom_minimum_size", default_size * selected_scale, time)

func on_unselected() -> void:
	add_tween("custom_minimum_size", default_size, time)

func add_tween(property: String, value, seconds: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(target, property, value, seconds).set_trans(transition_type)
