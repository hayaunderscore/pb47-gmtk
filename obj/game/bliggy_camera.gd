extends Camera2D

const LOOK_FACTOR = 0.125
var face = 1
@onready var prev = get_screen_center_position()

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.2  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var target : Node

func _ready() -> void:
	var target_offset = get_viewport_rect().size.x * LOOK_FACTOR * face
	position.x = target_offset
	reset_smoothing()
	
func add_trauma(amount, __target : Node2D):
	trauma = (trauma + amount) / max(1, (get_parent().position.distance_to(__target.position))/32)
	
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().health > 0:
		_check_face()
		prev = get_screen_center_position()
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func _check_face():
	var new = get_parent().facing
	if new != 0 && face != new:
		face = new
		var target_offset = get_viewport_rect().size.x * LOOK_FACTOR * face
		var tween = create_tween()
		tween.tween_property(self, "position:x", target_offset, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
