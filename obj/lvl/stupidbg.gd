extends Sprite2D

func _process(delta: float) -> void:
	offset.y -= 0.5 * delta*60
	if offset.y < -128:
		offset.y = 0
