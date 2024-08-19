extends Node2D

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
