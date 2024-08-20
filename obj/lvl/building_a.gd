extends Node2D

@onready var domumus = preload("res://mus/domu.ogg")

func _ready() -> void:
	$Tiles/Outside.modulate.a = 0
	
var outalpha = 0
var actualalpha = 0
	
func _process(delta: float) -> void:
	actualalpha = move_toward(actualalpha, outalpha, delta*6)
	$Tiles/Outside.modulate.a = actualalpha
	$Tiles/Inside.modulate.a = 1 - actualalpha

func _on_outside_shown_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		outalpha = 1
		
func _on_outside_shown_body_exited(body: Node2D) -> void:
	if body is Bliggy:
		outalpha = 0

var changed = false
func _on_changemoosic_body_entered(body: Node2D) -> void:
	if body is Bliggy:
		changed = true
		$CanvasLayer/Music.stream = domumus
		$CanvasLayer/Music.play()

var speedrun_started = false
func _on_start_speedrun_body_entered(body: Node2D) -> void:
	if speedrun_started:
		return
	if body is Bliggy:
		speedrun_started = true
		body.hud.speedrunTimer = true
