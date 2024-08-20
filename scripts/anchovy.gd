extends Enemy

func _physics_process(delta):
	if dead || nyeyehehe:
		velocity += get_gravity() * delta
		velocity.x += 10 * scale.x
		rotation_degrees += 4
		move_and_slide()
		return
		
func die():
	if dead:
		return
	$AnimatedSprite2D.play("Dead")
	velocity.y -= 400
	dead = true
	$Timer.start()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		scale.x = 1 * (body.facing*-1)
