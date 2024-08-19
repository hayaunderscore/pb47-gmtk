extends Area2D

@export var new_limit_origin : Vector2
@export var new_limit_size : Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		get_viewport().get_camera_2d().limit_left = new_limit_origin.x
		get_viewport().get_camera_2d().limit_top = new_limit_origin.y
		get_viewport().get_camera_2d().limit_right = new_limit_size.x
		get_viewport().get_camera_2d().limit_bottom = new_limit_size.y
