extends CanvasLayer

@onready var crect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crect.position.x -= crect.size.x*crect.scale.x
	var tween = create_tween()
	tween.tween_property(crect, "position:x", 0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	$Timer.start()
	$AnimatedSprite2D.play("4")
	$CheckpointText.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_health(health : int) -> void:
	$AnimatedSprite2D.play(str(health))

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(crect, "position:x", -(crect.size.x*crect.scale.x), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_checkpoint_text_time_timeout() -> void:
	var tween = create_tween()
	tween.tween_property($CheckpointText, "modulate:a", 0, 0.5)
