extends Sprite2D

var time = 0
var init_scale = 0

func _ready() -> void:
	init_scale = scale.x

func _process(delta: float) -> void:
	time += delta
	# print(sin(time*2))
	scale.x = sin(time*2) * init_scale
