extends Area2D

@export var bullet_speed = 15
var stop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2(1, 0).rotated(rotation) * bullet_speed
	if !stop:
		global_position += vel
	
func _on_timer_timeout() -> void:
	queue_free()

# Kill me
func should_collide(col : PhysicsBody2D) -> bool:
	if col.is_in_group("Player"):
		return false
	if col.is_in_group("Bullet"):
		return false
	return true

func _on_body_entered(body: Node2D) -> void:
	if (body is PhysicsBody2D && should_collide(body)) or body is TileMapLayer:
		get_viewport().get_camera_2d().add_trauma(0.2, self)
		if body is Enemy:
			if body.dead:
				return
		$BliggyBullet.visible = false
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("boomstick")
		$AnimatedSprite2D.position.x += randi_range(-32, 32)
		$AnimatedSprite2D.position.y += randi_range(-32, 32)
		$AnimatedSprite2D.rotation = -rotation
		$AnimatedSprite2D.scale.y = randf_range(0.5, 2)
		$AnimatedSprite2D.scale.x = $AnimatedSprite2D.scale.y
		$AudioStreamPlayer2D.play()
		stop = true
		$Timer.start()
		if body is Enemy:
			body.die()
