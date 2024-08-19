extends AnimatedSprite2D

func _ready() -> void:
	play("default")
	$AudioStreamPlayer2D.play()

func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
