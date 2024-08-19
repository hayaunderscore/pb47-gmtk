extends Control

func _process(delta: float):
	$ColorRect/RichTextLabel.position.y -= 0.5 * delta*60
	if Input.is_action_pressed("game_shoot"):
		$ColorRect/RichTextLabel.position.y -= 1.5 * delta*60
