extends Path2D

@export var label: Label
@export var sprite: Sprite2D
var direction: int
var type: String
var size: Vector2
var exists: bool = false
var time_to_live: float
var dying: bool = false
var player_bubble: bool = false

func _ready() -> void:
	self.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0).set_trans(Tween.TRANS_SINE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exists:
		time_to_live -= delta
		if time_to_live <= 0 and not dying:
			dying = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0).set_trans(Tween.TRANS_SINE)
			await tween.finished
			if not player_bubble:
				get_parent().call_deferred("next_bubble")
			else:
				get_parent().call_deferred("next_player_bubble")
			self.call_deferred("free")

func set_player():
	player_bubble = true
	sprite.modulate = Color(0, 1, 0, 1)

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
	if value:
		sprite.modulate = Color(1, 0, 0, 1)

func set_time(value: float):
	exists = true
	time_to_live = value

func set_truth_acquisition(value: String):
	sprite.set_meta("truth_acquisition", value)
	pass

func set_route(value: Dictionary):
	type = value["type"]
	sprite.call_deferred("set_speed", (value["speed"] as float) * (value["direction"] as float))
	if type == "rectangle":
		size = Vector2(value["width"] as float, value["height"] as float)
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
