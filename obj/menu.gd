extends Node

@onready var titlePart1 = $TitleHover
@onready var tutoral = $Tutoral
var state = 0
var time = 0

func _process(delta: float) -> void:
	time += delta
	if state == 0:
		titlePart1.visible = true
		tutoral.visible = false
		titlePart1.get_node("Sprite2D").offset.y = cos(time*3)*10
	elif state == 1:
		titlePart1.visible = false
		tutoral.visible = true
		pass
	
	# Handle input stuff
	if Input.is_action_just_pressed("game_shoot"):
		$Sounds/Select.play()
		if state == 1:
			SceneManager.change_scene("res://obj/lvl/building_a.tscn", {
				"pattern_enter": "diagonal",
				"pattern_leave": "squares"
			})
		state += 1
		
	if state > 1:
		state = 1
