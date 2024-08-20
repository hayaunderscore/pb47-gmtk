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
	
var time = 0.0
var speedrunTimer = false
	
static func get_time_as_formatted_string(time_in_seconds: float, format: String) -> String:
	var formatted_time: String = ""
	
	var total_seconds = int(time_in_seconds)
	
	@warning_ignore("integer_division")
	var hours : int = total_seconds / 3600
	
	@warning_ignore("integer_division")
	var minutes : int = (total_seconds % 3600) / 60
	
	@warning_ignore("integer_division")
	var seconds : int = total_seconds % 60
	
	@warning_ignore("integer_division")
	var days : int = total_seconds / 86400
	
	var fractional_part := time_in_seconds - int(time_in_seconds)
	
	var milliseconds := int(fractional_part * 1000)
	
	var i : int = 0
	while i < format.length():
		if format[i] == "{":
			var idx : int = format.find("}",i)
			
			if idx == -1:
				break
			
			match format[i+1]:
				"d":
					formatted_time += str(days).pad_zeros(idx-i-1)
				"h":
					formatted_time += str(hours).pad_zeros(idx-i-1)
				"m":
					formatted_time += str(int(fractional_part * pow(10,idx-i-1))).pad_zeros(idx-i-1)
				"M":
					formatted_time += str(minutes).pad_zeros(idx-i-1)
				"s":
					formatted_time += str(seconds).pad_zeros(idx-i-1)
					
			i = idx + 1
		else:
			formatted_time += format[i]
			i += 1
			
	return formatted_time
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_pause"):
		$Mario.play()
		get_tree().paused = not get_tree().paused
		$Music.stream_paused = get_tree().paused
		$VHSPause.visible = get_tree().paused
	if speedrunTimer && not get_tree().paused:
		time += delta
	$SpeedrunTime.text = "[right]" + str(get_time_as_formatted_string(time, "{MM}:{ss}.{mm}")) + "[/right]"
	pass
	
func change_health(health : int) -> void:
	$AnimatedSprite2D.play(str(health))

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(crect, "position:x", -(crect.size.x*crect.scale.x), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_checkpoint_text_time_timeout() -> void:
	var tween = create_tween()
	tween.tween_property($CheckpointText, "modulate:a", 0, 0.5)
