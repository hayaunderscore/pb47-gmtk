extends CharacterBody2D
class_name Enemy

const fella_speed = 100
var dir = 1

var dead = false
var nyeyehehe = false

func _physics_process(delta):
	if dead || nyeyehehe:
		return
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	$AnimatedSprite2D.play("Walk")
	velocity.x = fella_speed * dir
	# Switch directions
	if $Dir/WallCheck.is_colliding() && $Dir/WallCheck.get_collider() && $Dir/WallCheck.get_collider() is TileMapLayer:
		dir = dir * -1
	if not $Dir/FloorCheck.is_colliding():
		dir = dir * -1
	$Dir.scale.x = dir
	$AnimatedSprite2D.scale.x = dir
	move_and_slide()

func die():
	if dead:
		return
	$AnimatedSprite2D.play("Dead")
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	dead = true
	$Timer.start()

func _on_timer_timeout() -> void:
	var expl = preload("res://obj/game/explosion_dummy.tscn").instantiate()
	expl.global_position = global_position
	expl.get_node("AudioStreamPlayer2D").stream = preload("res://sfx/bloopExplode2.wav")
	get_parent().add_child(expl)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body && body.is_in_group("Player"):
		nyeyehehe = true
		body.hurt(1)
		$AnimatedSprite2D.play("Evil Grin")
		$Timer2.start()

func _on_timer_2_timeout() -> void:
	nyeyehehe = false
	pass # Replace with function body.
