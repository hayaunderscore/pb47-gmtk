extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		if body.health > 0:
			body.die()
