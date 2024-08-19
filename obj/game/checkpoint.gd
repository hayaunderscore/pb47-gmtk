extends Area2D

var checkpoint = false

func _on_body_entered(body: Node2D) -> void:
	if checkpoint:
		return
	checkpoint = true
	$AudioStreamPlayer2D.play()
	if body is Bliggy:
		body.cur_checkpoint = global_position
		body.show_chk_msg()
