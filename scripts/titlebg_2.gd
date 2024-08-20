extends Sprite2D

func _process(delta : float):
	offset.x -= 0.5 * (delta*60)
	offset.y -= 0.5 * (delta*60)
	if offset.x < -128:
		offset.x = 0
	if offset.y < -128:
		offset.y = 0
