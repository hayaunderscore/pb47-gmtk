extends Sprite2D

func _process(delta: float) -> void:
	scale.x = move_toward(scale.x, 0, delta*40)
	scale.y = scale.x
