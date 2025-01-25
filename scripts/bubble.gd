extends Path2D

@export var label: Label
@export var sprite: Sprite2D
var direction: int
var type: String
var size: Vector2
var exists: bool = false
var time_to_live: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exists:
		time_to_live -= delta
		if time_to_live <= 0:
			get_parent().call_deferred("next_bubble")
			self.call_deferred("free")
	pass

func pop_correct():
	#anim goes here
	get_parent().call_deferred("on_correct_bubble_destoryed")
	self.call_deferred("free")

func pop_incorrect():
	#anim goes here
	get_parent().call_deferred("on_incorrect_bubble_destoryed")
	self.call_deferred("free")

func set_start_pos(value: Vector2):
	self.position = value

func set_text(value: String):
	label.text = value

func set_truth(value: String):
	sprite.set_meta("truth", value)

func set_shootable(value: bool):
	sprite.set_meta("shootable", value)

func set_time(value: float):
	exists = true
	time_to_live = value

func set_route(value: Dictionary):
	type = value["type"]
	sprite.call_deferred("set_speed", value["speed"] * value["direction"])
	if type == "rectangle":
		size = Vector2(value["width"], value["height"])
		curve.add_point(Vector2(0, 0))
		curve.add_point(Vector2(size.x, 0))
		curve.add_point(Vector2(size.x, size.y))
		curve.add_point(Vector2(0, size.y))
		curve.add_point(Vector2(0, 0))
	else:
		var radius = value["size"] as float
		curve.add_point(Vector2(0, 0), Vector2(0, 0), Vector2(radius/2, -radius/2))
		curve.add_point(Vector2(radius, 0), Vector2(0, 0), Vector2(radius/2, radius/2))
		curve.add_point(Vector2(radius, radius), Vector2(0, 0), Vector2(-radius/2, radius/2))
		curve.add_point(Vector2(0, radius), Vector2(0, 0), Vector2(-radius/2, -radius/2))
		curve.add_point(Vector2(0, 0))
