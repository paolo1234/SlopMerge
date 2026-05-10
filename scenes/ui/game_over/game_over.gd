extends Control

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton

func _ready() -> void:
	var gm = get_node("/root/GameManager")
	score_label.text = "Score: " + str(gm.score)
	high_score_label.text = "Best: " + str(gm.high_score)
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Assicurati che il gioco sia in pausa ma la UI continui a funzionare
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_node("/root/GameManager").score = 0
	get_tree().reload_current_scene()
