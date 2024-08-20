extends Area2D

var checkpoint = false
var bdy : Bliggy

func _ready():
	$AnimatedSprite2D.play("RieHide")
	
func _process(delta: float) -> void:
	if not bdy:
		return
	# Face towards bliggy
	var face = round(global_position.direction_to(bdy.global_position).x)
	if face != 0:
		scale.x = face

func _on_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		if $AnimatedSprite2D.animation != "RieIdle":
			$AnimatedSprite2D.play("RieIdle")
		if checkpoint:
			return
		checkpoint = true
		$AudioStreamPlayer2D.play()
		body.cur_checkpoint = global_position
		body.show_chk_msg()

func _on_show_area_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		$AnimatedSprite2D.play("RieIdle")

func _on_show_area_body_exited(body: Node2D) -> void:
	if body is Bliggy:
		$AnimatedSprite2D.play("RiePeek")

func _on_peak_area_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		bdy = body as Bliggy
		$AnimatedSprite2D.play("RiePeek")

func _on_peak_area_body_exited(body: Node2D) -> void:
	if body is Bliggy:
		bdy = null
		$AnimatedSprite2D.play("RieHide")
