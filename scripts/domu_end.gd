extends Enemy

var hit = 0
@onready var fuckyou = $Timer3

func _physics_process(delta):
	if dead || nyeyehehe:
		velocity += get_gravity() * delta
		velocity.x += 10
		rotation_degrees += 4
		move_and_slide()
		return
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

func die():
	if not fuckyou.is_stopped():
		return
	hit += 1
	fuckyou.start()
	if hit == 1:
		$AnimatedSprite2D.play("Wot")
		return
	if dead:
		return
	$AnimatedSprite2D.play("Dead")
	$CollisionShape2D.set_deferred("disabled", true)
	velocity.y -= 400
	dead = true
	$Timer.start()
	
func _on_timer_timeout() -> void:
	var expl = preload("res://obj/game/explosion_dummy.tscn").instantiate()
	expl.global_position = global_position
	expl.get_node("AudioStreamPlayer2D").stream = preload("res://sfx/bloopExplode2.wav")
	get_parent().add_child(expl)
	visible = false
	get_parent().get_parent().get_node("CanvasLayer").speedrunTimer = false
	$Timer4.start()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass

func _on_timer_4_timeout() -> void:
	SceneManager.change_scene("res://obj/lvl/credits.tscn", {
		"pattern_enter": "diagonal",
		"pattern_leave": "curtains"
	})
