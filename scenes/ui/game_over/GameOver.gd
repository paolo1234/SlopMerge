extends CanvasLayer

@onready var score_label: Label = $Control/CenterPanel/VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $Control/CenterPanel/VBoxContainer/HighScoreLabel
@onready var restart_button: Button = $Control/CenterPanel/VBoxContainer/RestartButton
@onready var menu_button: Button = $Control/CenterPanel/VBoxContainer/MenuButton
@onready var center_panel: Panel = $Control/CenterPanel

func _ready() -> void:
	# Fondamentale: permetti alla UI di funzionare anche in pausa
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var gm = get_node("/root/GameManager")
	score_label.text = "Score: " + str(gm.score)
	high_score_label.text = "Best: " + str(gm.high_score)
	
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Entry Animation
	center_panel.scale = Vector2.ZERO
	center_panel.pivot_offset = center_panel.size / 2
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(center_panel, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	_setup_juice()

func _setup_juice() -> void:
	for btn in [restart_button, menu_button]:
		btn.pivot_offset = btn.size / 2
		btn.mouse_entered.connect(func(): 
			var t = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			t.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)
		)
		btn.mouse_exited.connect(func(): 
			var t = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			t.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
		)

func _on_restart_pressed() -> void:
	var gm = get_node("/root/GameManager")
	gm.is_game_over = false
	gm.score = 0
	get_tree().paused = false
	
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/levels/main/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")
	
	queue_free()

func _on_menu_pressed() -> void:
	var gm = get_node("/root/GameManager")
	gm.is_game_over = false
	gm.score = 0 # Reset score even when going to menu
	get_tree().paused = false
	
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
	
	queue_free()
