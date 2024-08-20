extends CharacterBody2D
class_name Bliggy

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var facing = 1
@onready var arrow = $Shotgun
@onready var jumptime = $JumpTimer
@onready var coyote = $WileTimer
@export var bullet : PackedScene
var time = 0
var wilee = false  # Track whether we're in coyote time or not
var last_floor = false
@onready var iframes = $iframes
var walktime = 0
@export var hud : CanvasLayer
var health = 4
var cur_checkpoint : Vector2
var checkpoint_msg = 0

@onready var brolyki = preload("res://obj/ui/broly_ki.tscn")
@onready var explosion = preload("res://obj/game/explosion_dummy.tscn")

func _ready():
	cur_checkpoint = global_position

func truly_not_on_floor() -> bool:
	return not is_on_floor() && coyote.is_stopped()

func _physics_process(delta: float) -> void:
	if health <= 0:
		velocity = Vector2.ZERO
		return
	
	# Add the gravity.
	if not is_on_floor() and last_floor:
		coyote.start()
		
	if truly_not_on_floor():
		velocity += get_gravity() * delta
	time += delta
	
	if not iframes.is_stopped():
		visible = floori(iframes.time_left*35) & 2
	else:
		visible = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("game_left", "game_right")
	if direction:
		if truly_not_on_floor():
			velocity.x = move_toward(velocity.x, direction*SPEED, SPEED/15)
			walktime = 0
		else:
			velocity.x = move_toward(velocity.x, direction*SPEED, SPEED/6)
			if walktime % 18 == 0:
				$Sounds/run.play()
			walktime += 1
		facing = direction
		if not truly_not_on_floor():
			$AnimatedSprite2D.play("Walk")
	else:
		if truly_not_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED/8)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/3)
		walktime = 0
		if not truly_not_on_floor():
			$AnimatedSprite2D.play("Idle")
	if truly_not_on_floor():
		$AnimatedSprite2D.play("Air")
		
	if $Sounds/hurt.playing:
		$AnimatedSprite2D.play("Ouch")
			
	# Handle arrow rotation bla bla
	var gundir_x := Input.get_axis("game_left", "game_right")
	var gundir_y := Input.get_axis("game_up", "game_down")
	
	if gundir_y == 0:
		gundir_x = facing
	
	if gundir_y > 0:
		arrow.get_node("BliggyShotgun").flip_v = false
		arrow.rotation_degrees = 180
		if gundir_x > 0:
			arrow.get_node("BliggyShotgun").flip_v = true
			arrow.scale.x = 1
			arrow.rotation_degrees = 180+45
		elif gundir_x < 0:
			arrow.get_node("BliggyShotgun").flip_v = true
			arrow.scale.x = -1
			arrow.rotation_degrees = 180-45
	elif gundir_y < 0:
		arrow.get_node("BliggyShotgun").flip_v = false
		arrow.rotation_degrees = 0
		if gundir_x > 0:
			arrow.scale.x = 1
			arrow.rotation_degrees = 45
		elif gundir_x < 0:
			arrow.scale.x = -1
			arrow.rotation_degrees = -45
	else:
		arrow.scale.x = 1
		if gundir_x > 0:
			arrow.rotation_degrees = 90
			arrow.get_node("BliggyShotgun").flip_v = false
		elif gundir_x < 0:
			arrow.rotation_degrees = -90
			arrow.get_node("BliggyShotgun").flip_v = true
	
	# Holy shit paper mario
	$AnimatedSprite2D.scale.x = move_toward($AnimatedSprite2D.scale.x, facing, delta*10)
	arrow.get_node("BliggyShotgun").offset.y = cos(time*4)*2
	arrow.get_node("BliggyShotgun").offset.x = move_toward(arrow.get_node("BliggyShotgun").offset.x, 0, delta*12)
	
	# Handle gun physics.
	if Input.is_action_just_pressed("game_shoot"):
		arrow.get_node("BliggyShotgun").offset.x = -16
		$Sounds/shotgun.play()
		for ang in range(-5, 6, 5):
			var inst = bullet.instantiate()
			# This is so fucking messy
			var point = arrow.get_node("BliggyShotgun").get_node("ShootPoint")
			get_parent().add_child(inst)
			inst.global_position = point.global_position
			inst.global_rotation_degrees = arrow.rotation_degrees-90+ang
		jumptime.start()
		
	if !jumptime.is_stopped():
		# Check for dir
		var mul = 5
		if is_on_floor():
			mul = 2
		if gundir_y > 0 && (is_on_floor() or not coyote.is_stopped()):
			if gundir_x:
				velocity.x = gundir_x * SPEED*3.5
			velocity.y = JUMP_VELOCITY
			jumptime.stop()
		elif gundir_y <= 0 && facing < 0 && $leftcheck.is_colliding():
			velocity.x = SPEED*mul
			if is_on_floor():
				velocity.y = JUMP_VELOCITY/2
			else:
				velocity.y = JUMP_VELOCITY/1.25
			jumptime.stop()
		elif gundir_y <= 0 && facing > 0 && $rightcheck.is_colliding():
			velocity.x = -SPEED*mul
			if is_on_floor():
				velocity.y = JUMP_VELOCITY/2
			else:
				velocity.y = JUMP_VELOCITY/1.25
			jumptime.stop()
		if gundir_y < 0 && $upcheck.is_colliding():
			velocity.y = -JUMP_VELOCITY/1.5
			jumptime.stop()
		coyote.stop()
		
	# This was originally here for debugging purposes.
	# if Input.is_action_pressed("ui_accept"):
	# 	die()
			
	last_floor = is_on_floor()
	move_and_slide()

func hurt(damage):
	# Do not deal additional damage when still in iframes
	if not iframes.is_stopped() or health <= 0:
		return
	velocity.y = JUMP_VELOCITY/2
	velocity.x = -facing * SPEED*2
	health -= damage
	if hud:
		hud.change_health(health)
	if health <= 0:
		die()
		return
	iframes.start()
	$Sounds/hurt.play()

func die():
	health = 0
	visible = true
	if hud:
		hud.change_health(health)
	$AnimatedSprite2D.play("Dead")
	add_child(brolyki.instantiate())
	$Sounds/sonic.play()
	$DeathTime1.start()

func _on_death_time_1_timeout() -> void:
	var expl = explosion.instantiate()
	expl.global_position = global_position
	expl.get_node("AudioStreamPlayer2D").stream = preload("res://sfx/bloopExplode2.wav")
	expl.speed_scale = 0.25
	expl.scale = Vector2(2, 2)
	get_viewport().get_camera_2d().add_trauma(1.5, self)
	get_parent().add_child(expl)
	visible = false
	$Sounds/explosion.play()
	$DeathTime2.start()

func _on_death_time_2_timeout() -> void:
	iframes.start()
	health = 4
	visible = true
	if hud:
		hud.change_health(4)
	global_position = cur_checkpoint
	
func show_chk_msg():
	if not hud:
		return
	var checkpointText = hud.get_node("CheckpointText")
	var tween = create_tween()
	tween.tween_property(checkpointText, "modulate:a", 1, 0.25)
	hud.get_node("CheckpointTextTime").start()
