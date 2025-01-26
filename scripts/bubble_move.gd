extends Sprite2D

@export var root: Node

@onready var parent = get_parent() as PathFollow2D
var speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pop_correct() -> void:
	$"../../bubblePop".play()
	root.call_deferred("pop_correct")

func pop_incorrect() -> void:
	$"../../bubblePop".play()
	root.call_deferred("pop_incorrect")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	parent.progress = parent.progress + speed * delta

func set_speed(value: float) -> void:
	speed = value
