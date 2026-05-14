extends CanvasLayer

@onready var score_label: Label = $Control/CenterPanel/VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $Control/CenterPanel/VBoxContainer/HighScoreLabel
@onready var restart_button: Button = $Control/CenterPanel/VBoxContainer/RestartButton
@onready var menu_button: Button = $Control/CenterPanel/VBoxContainer/MenuButton
@onready var center_panel: Panel = $Control/CenterPanel

func _ready() -> void:
	# Fondamentale: permetti alla UI di funzionare anche in pausa
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var score = 0
	var high_score = 0
	
	if has_node("/root/ScoreManager"):
		score = ScoreManager.score
		high_score = ScoreManager.high_score
	
	score_label.text = "Score: " + str(score)
	high_score_label.text = "Best: " + str(high_score)
	
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Entry Animation
	UIUtils.animate_pop_in(center_panel)
	
	_setup_juice()

func _setup_juice() -> void:
	UIUtils.setup_button(restart_button)
	UIUtils.setup_button(menu_button)

func _on_restart_pressed() -> void:
	restart_button.disabled = true
	menu_button.disabled = true
	
	print("[GameOver] Restart pressed")
	GameManager.is_game_over = false
	if has_node("/root/ScoreManager"):
		ScoreManager.reset_score()
	get_tree().paused = false
	
	TransitionManager.transition_to("res://scenes/levels/main/main.tscn")
	queue_free()

func _on_menu_pressed() -> void:
	restart_button.disabled = true
	menu_button.disabled = true
	
	print("[GameOver] Menu pressed")
	GameManager.is_game_over = false
	if has_node("/root/ScoreManager"):
		ScoreManager.reset_score() # Reset score even when going to menu
	get_tree().paused = false
	
	TransitionManager.transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	queue_free()
